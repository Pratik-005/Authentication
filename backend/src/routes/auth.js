const express = require("express");
const { signupfunc, signinfunc, googleAuth, logout } = require("../controllers/auth.js");

const router = new express.Router();

router.use(express.json());

router.post("/signup", signupfunc);

router.post("/signin", signinfunc);

router.post("/google", googleAuth);

router.post("/logout", logout);

module.exports = router;




