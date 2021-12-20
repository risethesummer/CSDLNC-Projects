using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using Backend.Database.Handler;
using Backend.Database.Dtos;

namespace Backend.Controllers
{
    [ApiController]
    [Route("product")]
    public class ProductController : ControllerBase
    {
        private readonly IProductRepository repository;

        public ProductController(IProductRepository repository)
        {
            this.repository = repository;
        }

        [HttpGet]
        public IEnumerable<CompactProductDto> GetProducts()
        {
            foreach (var product in repository.GetProducts())
                yield return product;
        }

         [HttpGet("{id}")]
        public ActionResult<ProductDto> GetProduct(int id)
        {
            try
            {
                return repository.GetProduct(id);
            }
            catch (Exception)
            {
                return BadRequest();
            }
        }
    }
}
