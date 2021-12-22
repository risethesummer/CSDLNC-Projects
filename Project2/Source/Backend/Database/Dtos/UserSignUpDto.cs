namespace Backend.Database.Dtos
{
    public record UserSignUpDto : UserDto
    {
        public string Name {init; get;}
        public string Address {init; get;}
        public string Phone {init; get;}
        public string Email {init; get;}
        public System.DateTime DayOfBirth {init; get;}
    }
}