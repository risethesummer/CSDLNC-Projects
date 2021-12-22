using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using Backend.Database.Handler;
using Backend.Database.Dtos;

namespace Backend.Controllers
{
    [ApiController]
    [Route("user")]
    public class UserController : ControllerBase
    {
        private readonly IUserRepository repository;

        public UserController(IUserRepository repository)
        {
            this.repository = repository;
        }

        //GET
        [HttpPost("signin")]
        public IActionResult SignInAccount(UserDto user)
        {
            try
            {
                var userInformation = repository.SignInAccount(user);
                return userInformation != null ? Ok(userInformation) : Unauthorized(); 
            }
            catch (Exception)
            {
                return BadRequest();
            }
        }

        [HttpPost("signup")]
        public IActionResult SignUpAccount(UserSignUpDto user)
        {
            try
            {
                if (repository.SignUpAccount(user))
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
