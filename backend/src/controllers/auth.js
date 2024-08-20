const User = require("../models/User");
const bcrypt = require("bcryptjs");
const myErrors = require("../../error.js");
const jwt = require("jsonwebtoken");

const signupfunc = async (req, res, next) => {
    try {

        const salt = bcrypt.genSaltSync(10);
        const hash = bcrypt.hashSync(req.body.password, salt);

        const dummyuser = new User({ ...req.body, password: hash });
        await dummyuser.save()

        const user = await User.findOne({ email: req.body.email });

        const token = jwt.sign({ id: user._id }, process.env.JWT_KEY);
        const { password, ...others } = user._doc;
        res.cookie("access_token", token, {
            httpOnly: true,
            sameSite: 'none',
            secure: true,
            path: '/',
            maxAge: 3600000,
        }).status(200).json(others);

    } catch (error) {
        next(myErrors(404, "user already exists !"));
        console.log(error)
    }
};




const signinfunc = async (req, res, next) => {
    try {
        const user = await User.findOne({ email: req.body.email });
        if (!user) return next(myErrors(404, "user not found !"));

        const isCorrect = await bcrypt.compare(req.body.password, user.password);
        if (!isCorrect) return next(myErrors(400, "incorrect credentials !"));

        const token = jwt.sign({ id: user._id }, process.env.JWT_KEY);
        const { password, ...others } = user._doc;

        res.cookie("access_token", token, {
            httpOnly: true,
            sameSite: 'none',
            secure: true,
            path: '/',
            maxAge: 3600000,
        }).status(200).json(others);

    } catch (error) {
        console.log(error)
        next(error)
    }
}



const googleAuth = async (req, res, next) => {
    try {
        const user = await User.findOne({ email: req.body.email });

        if (user) {
            const token = jwt.sign({ id: user._id }, process.env.JWT_KEY);
            res.cookie("access_token", token, {
                httpOnly: true,
                sameSite: 'none',
                secure: true,
                path: '/',
                maxAge: 3600000,
            }).status(200).json(user._doc);
        }
        else {

            const newUser = new User({ ...req.body, fromGoogle: true });
            const savedUser = await newUser.save();
            const token = jwt.sign({ id: savedUser._id }, process.env.JWT_KEY);

            res.cookie("access_token", token, {
                httpOnly: true,
                sameSite: 'none',
                secure: true,
                path: '/',
                maxAge: 3600000,
            }).status(200).json(savedUser._doc);
        }
    } catch (error) {
        next(error)
        console.log(error)
    }
};



const logout = async (req, res, next) => {
    try {
        res.clearCookie('access_token');
        res.status(200).json("Logged Out Successfully");
    } catch (error) {
        console.log(error)
        next(error)
    }
}




module.exports = { signupfunc, signinfunc, googleAuth, logout };

