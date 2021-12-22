using System;
using System.Data.SqlClient;
using Backend.Database.Dtos;
using System.Security.Cryptography;
using System.Text;
using Microsoft.Extensions.Configuration;

namespace Backend.Database.Handler
{
    public class UserDBManager : DBManager, IUserRepository
    {
        public UserDBManager(IConfiguration configuration) : base(configuration)
        {
        }

        private byte[] hashPassword(string password)
        {
            using var md5 = MD5.Create();
            return md5.ComputeHash(Encoding.ASCII.GetBytes(password));
        }

        public UserFullInformationDto SignInAccount(UserDto user)
        {
            try
            {
                using var connection = new SqlConnection(connectionString);
                connection.Open();
                using var command  = new SqlCommand("SELECT kh.MaKH, kh.HoTenKH, kh.DiaChiKH, kh.SDT_KH, kh.EmailKH, kh.NgaySinhKH, kh.DiemTichLuy, kh.SoTienDaDung FROM TAI_KHOAN tk JOIN KHACH_HANG kh ON tk.TaiKhoan = kh.TaiKhoan WHERE tk.TaiKhoan = @user_name AND tk.MatKhau = @password", connection);
                command.Parameters.AddWithValue("@user_name", user.UserName);
                command.Parameters.AddWithValue("@password", hashPassword(user.Password));
                using var reader = command.ExecuteReader();
                if (reader.Read())
                {
                    return new UserFullInformationDto(){
                        ID = reader.GetInt32(0),
                        Name = reader.GetString(1),
                        Address = reader.GetString(2),
                        Phone = reader.GetString(3),
                        Email = reader.GetString(4),
                        DayOfBirth = reader.GetDateTime(5),
                        RewardPoints = reader.GetInt32(6),
                        TotalUsedMoney = reader.GetDecimal(7),
                    };
                }
                return null;
            }
            catch (Exception)
            {
                return null;
            }
        }

        public bool SignUpAccount(UserSignUpDto user)
        {
            try
            {
                using var connection = new SqlConnection(connectionString);
                connection.Open();
                using var command  = new SqlCommand("tao_tai_khoan", connection) {CommandType = System.Data.CommandType.StoredProcedure};
                command.Parameters.AddWithValue("@tai_khoan", user.UserName);
                command.Parameters.AddWithValue("@mat_khau", hashPassword(user.Password));
                command.Parameters.AddWithValue("@ho_ten", user.Name);
                command.Parameters.AddWithValue("@dia_chi", user.Address);
                command.Parameters.AddWithValue("@sdt", user.Phone);
                command.Parameters.AddWithValue("@email", user.Email);
                command.Parameters.AddWithValue("@ng_sinh", user.DayOfBirth.Date);
                var a = command.ExecuteNonQuery();
                return a > 0;  
            }
            catch (Exception)
            {
                return false;
            }
        }
    }
}