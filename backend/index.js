const express = require("express");
const path = require('path');
const cookieParser = require("cookie-parser");
const cors = require("cors");

const envpath = path.join(__dirname, './.env');
require('dotenv').config({ path: envpath });


const connectToMongo = require('./src/db.js');
const authRoutes = require("./src/routes/auth.js");
const port = process.env.PORT;
const app = express();

app.use(cors({
  origin: true ,
  credentials: true
}));

app.use(cookieParser());
app.use(`/api/auth`, authRoutes);


app.use((err, req, res, next) => {
  const status = err.status || 500;
  const message = err.message || "Something went wrong";

  res.status(status).json({
    success: false,
    status,
    message,
  });
});


connectToMongo();

app.listen(port, () => {
  console.log(`The app is running on port ${port}`)
});


