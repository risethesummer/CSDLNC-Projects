using Microsoft.AspNetCore.Mvc;
using System;
using Backend.Database.Dtos;
using Backend.Database.Handler;
using Microsoft.AspNetCore.Cors;

namespace Backend.Controllers
{
    [EnableCors("AllowAllPolicy")]
    [ApiController]
    [Route("payment")]
    public class PaymentController : ControllerBase
    {
        private readonly IPaymentRepository repository;

        public PaymentController(IPaymentRepository repository)
        {
            this.repository = repository;
        }

        [HttpPost("atm/{orderID}")]
        public IActionResult PurchaseByATM(int orderID, AtmCardDto atmCard)
        {
            try
            {
                if (repository.PurchaseByAtm(orderID, atmCard))
                    return Ok();
                return Conflict();
            }
            catch (Exception)
            {
                return BadRequest();
            }
        }
        
        [HttpPost("cash/{orderID}")]
        public IActionResult PurchaseByATM(int orderID, decimal total)
        {
            try
            {
                if (repository.PurchaseByCash(orderID, total))
                    return Ok();
                return Conflict();
            }
            catch (Exception)
            {
                return BadRequest();
            }
        }
    }
}
