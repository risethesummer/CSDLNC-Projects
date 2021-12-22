using Backend.Database.Dtos;

namespace Backend.Database.Handler
{
    public interface IUserRepository
    {
        bool SignUpAccount(UserSignUpDto user);
        UserFullInformationDto SignInAccount(UserDto user);
    }
}