using Microsoft.EntityFrameworkCore;
using UserManagement.Models;

namespace UserManagement.DAL
{
    public class UserManagementDBContext: DbContext
    {

        public UserManagementDBContext()
        {

        }

        public UserManagementDBContext(DbContextOptions<UserManagementDBContext> options): base(options)
        {

        }

        public DbSet<User> Users { get; set; }

        //protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        //{
        //    if (!optionsBuilder.IsConfigured)
        //    {
        //        optionsBuilder.UseNpgsql("Host=localhost;Database=users;Username=postgres;Password=P@!ssw0rd3#");
        //    }
        //}
    }
}
