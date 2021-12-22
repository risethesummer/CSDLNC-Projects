using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Backend.Database.Dtos;
using Microsoft.Extensions.Configuration;

namespace Backend.Database.Handler
{
    public class CartDBManager : DBManager, ICartRepository
    {
        public CartDBManager(IConfiguration configuration) : base(configuration)
        {
        }

        public bool AddProduct(int userID, CompactProductAmountDto productAmountDto)
        {
            try
            {
                using var connection = new SqlConnection(connectionString);
                connection.Open();
                using var command  = new SqlCommand("them_san_pham_vao_gio_hang", connection) {CommandType = System.Data.CommandType.StoredProcedure};
                command.Parameters.AddWithValue("@ma_kh", userID);
                command.Parameters.AddWithValue("@ma_sp", productAmountDto.ProductID);
                command.Parameters.AddWithValue("@so_luong_them", productAmountDto.Amount);
                return command.ExecuteNonQuery() > 0;       
            }
            catch (Exception)
            {
                return false;
            }
        }

        public IEnumerable<ProductAmountDto> GetProductsFromCart(int userID)
        {
            try
            {
                using var connection = new SqlConnection(connectionString);
                connection.Open();
                using var command  = new SqlCommand("SELECT sp.MaSP, sp.TenSP, sp.MoTaSP, sp.LoaiSP, sp.SoLuongTonKho, sp.GiaSP, gh.SoLuongGioHang FROM GIO_HANG gh JOIN SAN_PHAM sp ON gh.MaSP = sp.MaSP WHERE gh.MaKH = @ma_kh", connection);
                command.Parameters.AddWithValue("@ma_kh", userID);
                using var reader = command.ExecuteReader();
                while (reader.Read())
                    yield return new ProductAmountDto()
                    {
                        ID = reader.GetInt32(0),
                        Name = reader.GetString(1),
                        Description = reader.GetString(2),
                        Type = reader.GetString(3),
                        StockAmount = reader.GetInt32(4),
                        Price = reader.GetDecimal(5),
                        Amount = (ushort)reader.GetInt32(6)
                    };
            } finally {}
        }
    }
}