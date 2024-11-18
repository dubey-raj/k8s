using Microsoft.AspNetCore.Mvc;
using UserManagement.DAL;
using UserManagement.Models;

namespace UserManagement.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UsersController : ControllerBase
    {
        private static readonly User[] users = new[] { 
        new User{ Id =1, Name = "Raj Dubey", UserName = "raj.dubey", CreatedDate = DateTimeOffset.UtcNow },
        new User{ Id =1, Name = "Less Jackson", UserName = "less.jackson", CreatedDate = DateTimeOffset.UtcNow },
        };

        private readonly ILogger<UsersController> _logger;
        private readonly UserManagementDBContext _context;
        public UsersController(ILogger<UsersController> logger, UserManagementDBContext context)
        {
            _logger = logger;
            _context = context;
        }

        /// <summary>
        /// Get all users
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public IEnumerable<User> GetUsers()
        {
            try
            {
                return _context.Users.ToList();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex,"error occured");
                throw;
            }
        }

        /// <summary>
        /// Login user
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("/token")]
        public string Login(User user)
        {
            return "eyddfd.rtet454535.gdfdgeter";
        }

        /// <summary>
        /// Add a new user
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        public string AddUser(User user)
        {
            _context.Users.Add(user);
            _context.SaveChanges();
            return "User added successfully";
        }
    }
}