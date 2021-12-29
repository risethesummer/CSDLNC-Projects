using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using Backend.Database.Handler;
using Backend.Database.Dtos;
using Microsoft.AspNetCore.Cors;

namespace Backend.Controllers
{
    [EnableCors("AllowAllPolicy")]
    [ApiController]
    [Route("cart")]
    public class CartController : ControllerBase
    {
        private readonly ICartRepository repository;

        public CartController(ICartRepository repository)
        {
            this.repository = repository;
        }

        [HttpGet("{userID}")]
        public IEnumerable<ProductAmountDto> ViewCart(int userID)
        {
            foreach (var product in repository.GetProductsFromCart(userID))
                yield return product;
        }

        [HttpPut("{userID}")]
        public IActionResult AddProduct(int userID, CompactProductAmountDto productAmount)
        {
            try
            {
                if (repository.AddProduct(userID, productAmount))
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
