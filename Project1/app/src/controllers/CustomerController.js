class CustomerController {
    async query(connection, query_str) {
        const request = connection.request();
        const result = await request.query(query_str);
        return result.recordset;
    }

    async list(
        connection,
        page = 1,
        page_size = 10,
        get_all = false,
        order_by = "Ma DESC",
        filter_query = ""
    ) {
        const paginate_str = `
          OFFSET ${page_size * (page - 1)} ROWS FETCH NEXT ${
            page_size + 1
        } ROWS ONLY
        `;
        const query_str = `
          SELECT *
          FROM KhachHang
          ${filter_query}
          ORDER BY ${order_by}
          ${!get_all ? paginate_str : "OFFSET 0 ROWS"};
        `;
        return await this.query(connection, query_str);
    }
}

module.exports = CustomerController;
