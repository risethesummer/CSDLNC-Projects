const db_connection = require("../db/connection");

module.exports = () => {
    return async (req, res, next) => {
        req.db = await db_connection();
        next();
    };
};
