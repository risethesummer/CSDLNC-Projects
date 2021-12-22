using Backend.Database.Dtos;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data.SqlClient;

namespace Backend.Database.Handler
{
    public class ProductDBManager : DBManager, IProductRepository
    {
        public ProductDBManager(IConfiguration configuration) : base(configuration)
        {
        }

        public ProductDto GetProduct(int productID)
        {
            try
            {
                using var connection = new SqlConnection(connectionString);
                connection.Open();
                using var command  = new SqlCommand("SELECT sp.MaSP, sp.TenSP, sp.MoTaSP, sp.LoaiSP, sp.GiaSP, sp.SoLuongTonKho FROM SAN_PHAM sp WHERE sp.MaSP = @ma_sp", connection);
                command.Parameters.AddWithValue("@ma_sp", productID);
                using var reader = command.ExecuteReader();
                if (reader.Read())
                    return new ProductDto()
                    {
                        ID = reader.GetInt32(0),
                        Name = reader.GetString(1),
                        Description = reader.GetString(2),
                        Type = reader.GetString(3),
                        Price = reader.GetDecimal(4),
                        StockAmount = reader.GetInt32(5)
                    };
                return null;       
            }
            catch (Exception)
            {
                return null;
            }
        }

        public IEnumerable<ProductDto> GetProducts()
        {
            try
            {
                using var connection = new SqlConnection(connectionString);
                connection.Open();
                using var command  = new SqlCommand("SELECT sp.MaSP, sp.TenSP, sp.MoTaSP, sp.LoaiSP, sp.GiaSP, sp.SoLuongTonKho FROM SAN_PHAM sp", connection);
                using var reader = command.ExecuteReader();
                while (reader.Read())
                    yield return new ProductDto()
                    {
                        ID = reader.GetInt32(0),
                        Name = reader.GetString(1),
                        Description = reader.GetString(2),
                        Type = reader.GetString(3),
                        Price = reader.GetDecimal(4),
                        StockAmount = reader.GetInt32(5)
                    };      
            } finally {}
        }
    }
}
