// @flow
"use strict";

const Router = require("express").Router;
const InvoiceController = require("../controllers/InvoiceController");
const CustomerController = require("../controllers/CustomerController");
const ProductController = require("../controllers/ProductController");
const _ = require("lodash");
const moment = require("moment");

module.exports = () => {
    const api = new Router();

    api.get("/", async (req, res) => {
        const controller = new InvoiceController();
        const page_size = 5;
        var page = 1;
        try {
            page = req.query.page ? parseInt(req.query.page) : 1;
        } catch (err) {
            page = 1;
        }
        const invoices = await controller.list(req.db, page, page_size);
        res.render("listing", {
            invoices: invoices[0].length ? invoices[0] : [],
            page_size,
            page: page,
        });
    });

    api.get("/reports/", async (req, res) => {
        const controller = new InvoiceController();
        const curDate = new moment();
        var year, month;
        try {
            year = parseInt(req.query.year ? req.query.year : curDate.year());
            month = parseInt(
                req.query.month ? req.query.month : curDate.month() + 1
            );
        } catch (err) {
            year = curDate.year();
            month = curDate.month() + 1;
        }
        const groupedInvoices = _.groupBy(
            await controller.report(req.db, year, month),
            "Ngay"
        );
        const result = [];
        const choosedMonth = moment(
            `${year}-${month.length < 2 ? "0" + month.toString() : month}`,
            "YYYY-MM"
        );
        const daysInMonth = choosedMonth.daysInMonth();
        for (let i = 1; i < daysInMonth; i++) {
            const indexStr = i.toString();
            result.push(
                groupedInvoices[indexStr]
                    ? groupedInvoices[indexStr][0]["TT"]
                    : 0
            );
        }
        res.render("report", {
            result,
            year,
            month,
        });
    });

    api.get("/add/", async (req, res) => {
        if (!req.query.customer) {
            const controller = new CustomerController();
            const page_size = 5;
            var page = 1;
            try {
                page = req.query.page ? parseInt(req.query.page) : 1;
            } catch (err) {
                page = 1;
            }
            const customers = await controller.list(req.db, page, page_size);
            res.render("add", {
                customers,
                page,
                page_size,
                have_customer: false,
            });
        } else {
            const controller = new ProductController();
            const page_size = 5;
            var page = 1;
            try {
                page = req.query.page ? parseInt(req.query.page) : 1;
            } catch (err) {
                page = 1;
            }
            const products = await controller.list(req.db, page, page_size);
            res.render("add", {
                products,
                page,
                page_size,
                have_customer: true,
                customer: req.query.customer,
            });
        }
    });

    api.post("/add/", async (req, res) => {
        if (req.query.customer) {
            const controller = new InvoiceController();
            await controller.create(req.db, req.query.customer, req.body.lines);
            res.sendStatus(200);
        } else {
            res.status(404).send("Sorry not found! 404!");
        }
    });

    return api;
};
