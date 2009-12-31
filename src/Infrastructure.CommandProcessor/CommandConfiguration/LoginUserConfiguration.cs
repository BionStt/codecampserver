using CodeCampServer.Core.Services.BusinessRule.Login;
using CodeCampServer.UI;
using Tarantino.RulesEngine.Configuration;
using Tarantino.RulesEngine.ValidationRules;

namespace CodeCampServer.Infrastructure.CommandProcessor.CommandConfiguration
{
	public class LoginUserConfiguration : MessageDefinition<LoginInputProxy>
	{
		public LoginUserConfiguration()
		{
			Execute<LoginUserCommandMessage>().Enforce(v =>
           		{
           			v.Rule<ValidateNotNull>(c => c.Username).RefersTo(m => m.Username);
           			v.Rule<ValidateNotNull>(c => c.Password).RefersTo(m => m.Password);
           		});
		}
	}
}