namespace Backend.Database.Dtos
{
    public record PaymentCashDto : PaymentDto
    {
        public decimal ExcessCash {init; get;}
    }
}