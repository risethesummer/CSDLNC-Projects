using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Backend.Database.Dtos;
using Microsoft.Extensions.Configuration;

namespace Backend.Database.Handler
{
    public class PaymentDBManager : DBManager, IPaymentRepository
    {
        public PaymentDBManager(IConfiguration configuration) : base(configuration)
        {
        }

        public bool PurchaseByAtm(int orderID, AtmCardDto atm)
        {
           try
            {
                using var connection = new SqlConnection(connectionString);
                connection.Open();
                using var command  = new SqlCommand("thanh_toan_don_hang_atm", connection) {CommandType = System.Data.CommandType.StoredProcedure};
                command.Parameters.AddWithValue("@ma_dh", orderID);
                command.Parameters.AddWithValue("@so_tk", atm.Number);
                command.Parameters.AddWithValue("@ten_tk", atm.Owner);
                command.Parameters.AddWithValue("@ngan_hang", atm.Bank);
                return command.ExecuteNonQuery() > 0;       
            }
            catch (Exception)
            {
                return false;
            }
        }

        public bool PurchaseByCash(int orderID, decimal cash)
        {
            try
            {
                using var connection = new SqlConnection(connectionString);
                connection.Open();
                using var command  = new SqlCommand("thanh_toan_don_hang_tien_mat", connection) {CommandType = System.Data.CommandType.StoredProcedure};
                command.Parameters.AddWithValue("@ma_dh", orderID);
                command.Parameters.AddWithValue("@cash", cash);
                return command.ExecuteNonQuery() > 0;       
            }
            catch (Exception)
            {
                return false;
            }
        }
    }
}