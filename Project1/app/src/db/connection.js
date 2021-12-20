const sql = require("mssql");

const config = {
    user: "SA",
    userName: "SA", // update me
    password: "123456", // update me
    database: "cua_hang",
    server: "(LocalDB)\\MSSQLLocalDB",
    parseJSON: true,
    port: 1434,
    pool: {
        max: 10,
        min: 0,
        idleTimeoutMillis: 30000,
    },
    options: {
        encrypt: true, // for azure
        trustServerCertificate: true, // change to true for local dev / self-signed certs
    },
};

module.exports = () => {
    sql.close();
    connection = sql.connect(config);
    return connection;
};
