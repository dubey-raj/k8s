using Microsoft.EntityFrameworkCore;
using UserManagement.DAL;

namespace UserManagement
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            builder.Services.AddControllers();
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen(options =>
            {
                var xmlFile = $"{System.Reflection.Assembly.GetExecutingAssembly().GetName().Name}.xml";
                var xmlPath = Path.Combine(AppContext.BaseDirectory, xmlFile);
                options.IncludeXmlComments(xmlPath);
            });
            builder.Services.AddTransient<UserManagementDBContext>();
            builder.Configuration.AddEnvironmentVariables();
            builder.Services.AddDbContext<UserManagementDBContext>(options =>
            {
                var host = builder.Configuration.GetValue<string>("Host") ?? throw new NotImplementedException("Database host was missing");
                var database = builder.Configuration.GetValue<string>("Database")?? throw new NotImplementedException("Database name was missing");
                var userName = builder.Configuration.GetValue<string>("DB_UserName") ?? throw new NotImplementedException("Database user name was missing");
                var password = builder.Configuration.GetValue<string>("DB_Password") ?? throw new NotImplementedException("Database password was missing");
                var conStr = $"Host={host};Database={database};Username={userName};Password={password}";
                var port = builder.Configuration.GetValue<string>("DB_Port");
                if (!string.IsNullOrEmpty(port))
                {
                    conStr += $";Port={port}";
                }
                options.UseNpgsql(conStr);
            });
            var app = builder.Build();

            app.UseSwagger();
            app.UseSwaggerUI();
            app.UseHttpsRedirection();
            app.UseAuthorization();
            app.MapControllers();

            app.Run();
        }
    }
}