namespace Backend.Database.Dtos
{
    public record CompactProductAmountDto
    {
        public int ProductID {init; get;}
        public int Amount {init; get;}
    }
}