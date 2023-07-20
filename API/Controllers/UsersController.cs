using API.Data;
using API.DTOs;
using API.Entities;
using API.Interfaces;
using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace API.Controllers
{
    [Authorize]
    // [AllowAnonymous] // test
    public class UsersController : BaseApiController
    {
        private readonly IUserRepository _userRepository;
        private readonly IMapper _mapper;
        public UsersController(IUserRepository userRepository, IMapper mapper)
        {
            _mapper = mapper;
            _userRepository = userRepository;
  
        }

        // [AllowAnonymous]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<MemberDto>>> GetUsers()
        {
            // var users = await _userRepository.GetUsersAsync();
            var users = await _userRepository.GetMembersAsync();

            // var usersToReturn = _mapper.Map<IEnumerable<MemberDto>>(users);

            return Ok(users);
        }

        [HttpGet("{username}")]
        public async Task<ActionResult<MemberDto>> GetUser(string username)
        {
            // var user = await _userRepository.GetUserByUsernameAsync(username);
            return await _userRepository.GetMemberAsync(username);

            // return _mapper.Map<MemberDto>(user);
        }
    }
}