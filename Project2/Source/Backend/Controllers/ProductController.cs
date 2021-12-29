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
    [Route("product")]
    public class ProductController : ControllerBase
    {
        private readonly IProductRepository repository;

        public ProductController(IProductRepository repository)
        {
            this.repository = repository;
        }

        [HttpGet]
        public IEnumerable<ProductDto> GetProducts()
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
