﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
{{LoggingPackageSpecificUsing}}

namespace {{Project}}
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            RouteConfig.RegisterRoutes(RouteTable.Routes);
			
			{{{LoggingPackageSpecific}}}
        }
    }
}
