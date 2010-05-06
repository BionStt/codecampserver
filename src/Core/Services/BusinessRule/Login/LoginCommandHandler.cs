using CodeCampServer.Core.Domain.Bases;

namespace CodeCampServer.Core.Services.BusinessRule.Login
{
	public class LoginCommandHandler : ICommand<LoginUserCommandMessage>
	{
		private readonly IAuthenticationService _authenticationService;
		private readonly IUserRepository _repository;

		public LoginCommandHandler(IAuthenticationService authenticationService,
		                           IUserRepository repository)
		{
			_authenticationService = authenticationService;
			_repository = repository;
		}

		public object Execute(LoginUserCommandMessage commandMessage)
		{
			var user = _repository.GetByUserName(commandMessage.Username);
			if (user != null)
			{
				if (_authenticationService.PasswordMatches(user, commandMessage.Password))
				{
					return user;
				}
			}
			return null;
		}
	}
}