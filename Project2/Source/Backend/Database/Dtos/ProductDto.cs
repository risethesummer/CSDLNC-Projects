namespace Backend.Database.Dtos
{
    public record ProductDto
    {
        public int ID { init; get; }
        public string Name { init; get; }
        public string Description { init; get; }
        public int StockAmount { init; get; }
        public string Type {init; get;}
        public decimal Price {init; get;}
    }
}
