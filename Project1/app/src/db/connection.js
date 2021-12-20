const sql = require("mssql");

const config = {
    user: "csdlnc",
    userName: "csdlnc", // update me
    password: "csdlnc", // update me
    database: "cua_hang",
    server: "(LocalDB)\\MSSQLLocalDB",
    parseJSON: true,
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
