namespace Backend.Database.Dtos
{
    public record ImageDto
    {
        public string ContentType {init; get;}
        public byte[] Content {init; get;}
    }
}