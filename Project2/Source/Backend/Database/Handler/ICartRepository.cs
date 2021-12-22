using Backend.Database.Dtos;

namespace Backend.Database.Handler
{
    public interface ICartRepository
    {
        bool AddProduct(int userID, CompactProductAmountDto productAmountDto);
        System.Collections.Generic.IEnumerable<ProductAmountDto> GetProductsFromCart(int userID);
    }
}