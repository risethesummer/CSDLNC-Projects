using Backend.Database.Dtos;

namespace Backend.Database.Handler
{
    public interface IPaymentRepository 
    {
        bool PurchaseByAtm(int orderID, AtmCardDto atm);
        bool PurchaseByCash(int orderID, decimal cash);
    }
}