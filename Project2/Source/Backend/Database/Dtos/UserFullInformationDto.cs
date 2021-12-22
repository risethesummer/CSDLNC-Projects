namespace Backend.Database.Dtos
{
    public record UserFullInformationDto : UserSignUpDto
    {
        public int ID {get; init;}
        public int RewardPoints {get;init;}
        public decimal TotalUsedMoney {get; init;}
    }
}