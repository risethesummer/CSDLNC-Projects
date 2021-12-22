using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Backend.Database.Dtos;
using Microsoft.Extensions.Configuration;

namespace Backend.Database.Handler
{
    public class OrderDBManager : DBManager, IOrderRepository
    {
        public OrderDBManager(IConfiguration configuration) : base(configuration)
        {
        }

        public bool CreateOrder(int userID)
        {
            try
            {
                using var connection = new SqlConnection(connectionString);
                connection.Open();
                using var command  = new SqlCommand("tao_don_hang", connection) {CommandType = System.Data.CommandType.StoredProcedure};
                command.Parameters.AddWithValue("@ma_kh", userID);
                return command.ExecuteNonQuery() > 0;       
            }
            catch (Exception)
            {
                return false;
            }
        }

        public IEnumerable<ProductAmountInOrderDto> GetProductsInOrder(int orderID)
        {
            using var connection = new SqlConnection(connectionString);
            connection.Open();
            using var getDetailedCommand = new SqlCommand("SELECT sp.MaSP, sp.TenSP, sp.MoTaSP, sp.LoaiSP, sp.SoLuongTonKho, ctdh.DonGiaDH, ctdh.GiaGiamDH, ctdh.SoLuongDH FROM CHI_TIET_DON_HANG ctdh JOIN SAN_PHAM sp ON ctdh.MaSP = sp.MaSP WHERE ctdh.MaDH = @ma_dh", connection);
            getDetailedCommand.Parameters.AddWithValue("@ma_dh", orderID);
            using var productReader = getDetailedCommand.ExecuteReader();
            while (productReader.Read())
            {
                yield return new ProductAmountInOrderDto()
                {
                    ID = productReader.GetInt32(0),
                    Name = productReader.GetString(1),
                    Description = productReader.GetString(2),
                    Type = productReader.GetString(3),
                    StockAmount = productReader.GetInt32(4),
                    Price = productReader.GetDecimal(5),
                    Discount = productReader.GetDecimal(6),
                    Amount = (ushort)productReader.GetInt32(7)
                };
            }
        }

        public IEnumerable<OrderDto> GetProcessingOrders(int userID)
        {
            try
            {
                using var connection = new SqlConnection(connectionString);
                connection.Open();
                using var getOrdersCommand = new SqlCommand("SELECT dh.MaDH, dh.NgayLapDH, dh.TrangThaiDH, dh.TongGiaDH FROM DON_HANG dh WHERE dh.MaKH = @ma_kh AND dh.TrangThaiDH = N'Đang xử lý'", connection);
                getOrdersCommand.Parameters.AddWithValue("@ma_kh", userID);
                using var ordersReader = getOrdersCommand.ExecuteReader();
                while (ordersReader.Read())
                {
                    var orderID = ordersReader.GetInt32(0);
                    yield return new OrderDto()
                    {
                        OrderID = orderID,
                        Date = ordersReader.GetDateTime(1),
                        State = ordersReader.GetString(2),
                        TotalPrice = ordersReader.GetDecimal(3),
                        Products = GetProductsInOrder(orderID)
                    };
                }
            }
            finally { }
        }

        public IEnumerable<OrderPaymentDto> GetPaidOrders(int userID)
        {
            try
            {
                using var connection = new SqlConnection(connectionString);
                connection.Open();
                using var getOrdersCommand = new SqlCommand("xem_don_hang_da_thanh_toan", connection) {CommandType = System.Data.CommandType.StoredProcedure};
                getOrdersCommand.Parameters.AddWithValue("@ma_kh", userID);
                var ordersReader = getOrdersCommand.ExecuteReader();
                while (ordersReader.Read())
                {
                    var orderID = ordersReader.GetInt32(0);
                    yield return new OrderPaymentDto()
                    {
                        OrderID = orderID,
                        Date = ordersReader.GetDateTime(1),
                        State = ordersReader.GetString(2),
                        TotalPrice = ordersReader.GetDecimal(3),
                        Products = GetProductsInOrder(orderID),
                        Payment = new PaymentATMDto(){
                            Date = ordersReader.GetDateTime(4),
                            PaymentType = "ATM",
                            ATMCard = new AtmCardDto()
                            {
                                Number = ordersReader.GetString(5),
                                Owner = ordersReader.GetString(6),
                                Bank = ordersReader.GetString(7)
                            }
                        }
                    };
                }

                if (ordersReader.NextResult())
                {
                    while (ordersReader.Read())
                    {
                        var orderID = ordersReader.GetInt32(0);
                        yield return new OrderPaymentDto()
                        {
                            OrderID = orderID,
                            Date = ordersReader.GetDateTime(1),
                            State = ordersReader.GetString(2),
                            TotalPrice = ordersReader.GetDecimal(3),
                            Products = GetProductsInOrder(orderID),
                            Payment = new PaymentCashDto()
                            {
                                Date = ordersReader.GetDateTime(4),
                                PaymentType = "Tiền mặt",
                                ExcessCash = ordersReader.GetDecimal(5)
                            }
                        };
                    }
                }
            }
            finally { }
        }
    }
}