namespace Backend.Database.Dtos
{
    public record AtmCardDto
    {
        public string Number {init; get;}
        public string Owner {init; get;}
        public string Bank {init; get;}
    }
}