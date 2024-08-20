const jwt = require("jsonwebtoken");
const myErrors = require("./error");

const verifyUser = (req, res, next) => {

    const token = req.cookies.access_token;
    if (!token) return next(myErrors(401, "you are not authenticated !"));

    jwt.verify(token, process.env.JWT_KEY, (err, user) => {
        if (err) return next(myErrors(403, "Token is not valid !"));
        req.user = user;
        next();
    });
    
};


module.exports = verifyUser;




