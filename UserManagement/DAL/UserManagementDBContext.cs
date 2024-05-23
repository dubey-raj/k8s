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
    }
}
