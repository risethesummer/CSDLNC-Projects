namespace Backend.Database.Dtos
{
    public record ProductAmountInOrderDto : ProductAmountDto
    {
        public decimal Discount {init; get;}
    }
}