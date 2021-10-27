// @flow
"use strict";

const express = require("express");
const cluster = require("cluster");
const bodyParser = require("body-parser");
const logger = require("morgan");
const cors = require("cors");
const helmet = require("helmet");
const databaseMiddleware = require("./middlewares/databaseMiddleware");
const os = require("os");
const path = require("path");
const invoiceRoute = require("./routes/invoiceRoute");

require("dotenv").config();

require("core-js/stable");
require("regenerator-runtime/runtime");

const numCPUs = os.cpus().length;

if (cluster.isMaster) {
    for (let i = 0; i < numCPUs; i++) {
        cluster.fork();
    }

    cluster.on("exit", (worker) => {
        console.log(`worker ${worker.process.pid} died`);
    });
    cluster.on("death", (worker) => {
        console.log(`Worker ${worker.pid} died.`);
    });
} else {
    const app = express();
    app.set("port", process.env.PORT || 3000);
    app.set("view engine", "ejs");
    app.set("views", path.join(__dirname, "../src", "views"));
    app.use("/static", express.static("static"));
    app.use(logger("dev"));
    app.use(bodyParser.json({ limit: "10mb" }));
    app.use(bodyParser.urlencoded({ extended: false }));
    app.use(bodyParser.raw());
    app.use(cors());
    app.use(helmet());
    app.use(databaseMiddleware());

    process.on("unhandledRejection", (reason, p) => {
        console.log("Unhandled Rejection at: Promise", p, "reason:", reason);
    });

    app.use("/", invoiceRoute());

    app.use((req, res) => {
        res.status(404).send("Sorry not found! 404!");
    });

    app.use((req, res) => {
        res.status(500).send("Sorry! Something broke!");
    });

    app.listen(app.get("port"));
    console.log(`App listening on ${app.get("port")}`);
}
