namespace Backend.Database.Dtos
{
    public record PaymentDto
    {
        public System.DateTime Date {get; init;}
        public string PaymentType {get; init;}
    }
}