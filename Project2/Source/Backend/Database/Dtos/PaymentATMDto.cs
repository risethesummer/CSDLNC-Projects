namespace Backend.Database.Dtos
{
    public record PaymentATMDto : PaymentDto
    {
        public AtmCardDto ATMCard {init; get;}
    }
}