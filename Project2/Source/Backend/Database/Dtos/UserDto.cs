namespace Backend.Database.Dtos
{
    public record UserDto
    {
        public string UserName {init; get;}
        public string Password {init; get;}
    }
}