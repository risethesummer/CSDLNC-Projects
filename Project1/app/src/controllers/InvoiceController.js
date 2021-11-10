class InvoiceController {
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
        order_by = "NgayLap DESC",
        filter_query = ""
    ) {
        const paginate_str = `
          OFFSET ${page_size * (page - 1)} ROWS FETCH NEXT ${
            page_size + 1
        } ROWS ONLY
        `;
        const query_str = `
          SELECT *
          FROM (
            SELECT *
            FROM HoaDon
            ${filter_query}
            ORDER BY ${order_by}
            ${!get_all ? paginate_str : "OFFSET 0 ROWS"}
          ) AS PAGINATED
          INNER JOIN HoaDonChiTiet AS lines ON PAGINATED.Ma = lines.MaHD
          FOR JSON AUTO;
        `;
        return await this.query(connection, query_str);
    }

    async report(connection, year, month) {
        const query_str = `
          SELECT DAY(HoaDon.NgayLap) Ngay, SUM(HoaDon.TongTien) TT
          FROM HoaDon
          WHERE YEAR(HoaDon.NgayLap) = ${year} AND MONTH(HoaDon.NgayLap) = ${month}
          GROUP BY DAY(HoaDon.NgayLap)
        `;
        return await this.query(connection, query_str);
    }

    async last(connection) {
        const query_str = `
          SELECT * 
          FROM HoaDon
          ORDER BY Ma DESC
          OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY
        `;
        const list = await this.query(connection, query_str);
        return list.length > 0 ? list[0] : null;
    }

    async create(connection, customer, lines) {
        const last = await this.last(connection);
        var code = null;
        if (!last) {
            code = "hd" + `${1}`.padStart(6, "0");
        } else {
            code =
                "hd" +
                `${parseInt(last.Ma.replace("hd", "")) + 1}`.padStart(6, "0");
        }
        var query_str = `
        INSERT INTO HoaDon (Ma, MaKH, TongTien) VALUES ('${code}', '${customer}',0);
        INSERT INTO HoaDonChiTiet (MaHD, MaSP, SoLuong, GiaGiam) VALUES 
        `;

        lines.forEach(function (line, idx) {
            query_str += `('${code}', '${line.MaSP}', ${line.SoLuong}, ${line.GiaGiam})`;
            query_str += idx === lines.length - 1 ? ";" : ",";
        });

        return await this.query(connection, query_str);
    }
}

module.exports = InvoiceController;
