const mongoose = require("mongoose");

const connectToMongo = () => {

    try {
        mongoose.connect(process.env.MONGO_URI);
        console.log("Successfully connected to MongoDB");
    } catch (error) {
        console.error(error);
    }

}

module.exports = connectToMongo;