namespace Backend.Database.Dtos
{
    public record OrderPaymentDto : OrderDto
    {
        public PaymentDto Payment {get; init;}
    }
}