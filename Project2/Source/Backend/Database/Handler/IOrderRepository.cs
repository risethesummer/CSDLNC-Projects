using System.Collections.Generic;

namespace Backend.Database.Handler
{
    public interface IOrderRepository
    {
        bool CreateOrder(int userID);
        IEnumerable<Dtos.OrderDto> GetProcessingOrders(int userID);
        IEnumerable<Dtos.OrderPaymentDto> GetPaidOrders(int userID);

        IEnumerable<Dtos.ProductAmountInOrderDto> GetProductsInOrder(int orderID);
    }
}