namespace Backend.Database.Dtos
{
    public record ProductDto : CompactProductDto
    {
        public int TypeID { init; get; }
        public string TypeName { init; get; }
    }
}
