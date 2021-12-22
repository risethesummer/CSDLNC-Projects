namespace Backend.Database.Dtos
{
    public record OrderDto
    {
        public int OrderID {init; get;}
        public System.DateTime Date {init; get;}
        public System.Collections.Generic.IEnumerable<ProductAmountInOrderDto> Products {init; get;}
        public string State {init; get;}
        public decimal TotalPrice {init; get;}
    }
}