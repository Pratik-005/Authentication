const { Schema } = require("mongoose");
const mongoose = require("mongoose");

const UserSchema = new Schema({
    name: {
        type: String,
    },
    email: {
        type: String,
        required: true,
        unique: true,
    },
    password: {
        type: String,
        default:"password"
    },
    img: {
        type: String,
        default: "https://cdn-icons-png.flaticon.com/512/3237/3237472.png"
    },
    fromGoogle: {
        type: Boolean,
        default: false,
    }
},
    { timestamps: true }
);

module.exports = mongoose.model("User", UserSchema);

