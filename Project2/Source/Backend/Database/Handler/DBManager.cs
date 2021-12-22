using Microsoft.Extensions.Configuration;

namespace Backend.Database.Handler
{
    public abstract class DBManager
    {
        protected string connectionString;

        public DBManager(IConfiguration configuration)
        {
            this.connectionString = configuration.GetConnectionString("Default");
        }
    }
}