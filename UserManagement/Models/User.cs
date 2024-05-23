using System.Text.Json.Serialization;

namespace UserManagement.Models
{
    public class User
    {
        public int Id { get; set; }

        public string Name { get; set; }

        public string UserName { get; set; }

        [JsonIgnore]
        public DateTimeOffset CreatedDate { get; set; } = DateTimeOffset.Now;
    }
}