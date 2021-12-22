using System.Collections.Generic;
using Backend.Database.Dtos;

namespace Backend.Database.Handler
{
    public interface IProductRepository
    {
        IEnumerable<ProductDto> GetProducts();
        ProductDto GetProduct(int productID);
    }
}