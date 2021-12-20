using Backend.Database.Dtos;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data.SqlClient;

namespace Backend.Database.Handler
{
    public class ProductDBManager : IProductRepository
    {
        private readonly string connectionString;

        public ProductDBManager(IConfiguration configuration)
        {
            connectionString = configuration.GetConnectionString("Default");
        }

        public ProductDto GetProduct(int productID)
        {
            try
            {
                using var connection = new SqlConnection(connectionString);
                connection.Open();
                using var command  = new SqlCommand("SELECT sp.* FROM SAN_PHAM sp WHERE sp.MaSP = @ma_sp", connection);
                command.Parameters.AddWithValue("@ma_sp", productID);
                using var reader = command.ExecuteReader();
                if (reader.Read())
                    return new ProductDto()
                    {
                        ID = reader.GetInt32(0),
                        Name = reader.GetString(1),
                        Description = reader.GetString(2),
                        StockAmount = reader.GetInt32(3),
                        TypeID = reader.GetInt32(4),
                        TypeName = reader.GetString(5),
                        Price = reader.GetDecimal(6)
                    };
                return null;       
            }
            catch (Exception)
            {
                return null;
            }
        }

        public IEnumerable<CompactProductDto> GetProducts()
        {
            try
            {
                using var connection = new SqlConnection(connectionString);
                connection.Open();
                using var command  = new SqlCommand("SELECT sp.MaSP, sp.TenSP, sp.MoTaSP, sp.Gia, sp.SoLuongTonKho FROM SAN_PHAM sp", connection);
                using var reader = command.ExecuteReader();
                while (reader.Read())
                    yield return new CompactProductDto()
                    {
                        ID = reader.GetInt32(0),
                        Name = reader.GetString(1),
                        Description = reader.GetString(2),
                        Price = reader.GetDecimal(3),
                        StockAmount = reader.GetInt32(4)
                    };      
            } finally {}
        }
    }
}
