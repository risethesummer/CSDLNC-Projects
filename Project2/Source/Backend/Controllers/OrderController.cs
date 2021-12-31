using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using Backend.Database.Handler;
using Backend.Database.Dtos;
using Microsoft.AspNetCore.Cors;

namespace Backend.Controllers
{
    [EnableCors("AllowAllPolicy")]
    [ApiController]
    [Route("order")]
    public class OrderController : ControllerBase
    {
        private readonly IOrderRepository repository;

        public OrderController(IOrderRepository repository)
        {
            this.repository = repository;
        }

        [HttpPut("{userID}")]
        public IActionResult CreateOrder(int userID)
        {
            try
            {
                if (repository.CreateOrder(userID))
                    return Ok();
                return Conflict();
            }
            catch (Exception)
            {
                return BadRequest();
            }
        }


        [HttpGet("processing/{userID}")]
        public IEnumerable<OrderDto> ViewProcessingOrders(int userID)
        {
            try
            {
                foreach (var order in repository.GetProcessingOrders(userID))
                    yield return order;
            } finally {};
        }

        [HttpGet("paid/{userID}")]
        public IEnumerable<OrderPaymentDto> ViewPaidOrders(int userID)
        {
            try
            {
                foreach (var order in repository.GetPaidOrders(userID))
                    yield return order;
            } finally {};
        }
    }
}
