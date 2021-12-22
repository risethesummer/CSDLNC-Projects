namespace Backend.Database.Dtos
{
    public record ProductAmountDto : ProductDto
    {
        public ushort Amount {init; get;}
    }
}