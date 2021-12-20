using System.Collections.Generic;
using Backend.Database.Dtos;

namespace Backend.Database.Handler
{
    public interface IProductRepository
    {
        IEnumerable<CompactProductDto> GetProducts();
        ProductDto GetProduct(int productID);
    }
}