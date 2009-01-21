﻿using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using CodeCampServer.DependencyResolution;

namespace CodeCampServer.UI
{
	public class GlobalApplication : HttpApplication
	{
		public static void RegisterRoutes(RouteCollection routes)
		{
			routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
			routes.IgnoreRoute("{resource}.gif/{*pathInfo}");

			new RouteConfigurator().RegisterRoutes();
		}

		protected void Application_Start()
		{
			RegisterRoutes(RouteTable.Routes);
			AutoMapperConfiguration.Configure();
			ControllerBuilder.Current.SetControllerFactory(new ControllerFactory());

			ModelBinders.DefaultBinder = new SmartBinder();
		}
	}
}