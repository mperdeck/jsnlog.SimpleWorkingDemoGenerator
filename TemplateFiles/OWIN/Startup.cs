using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using Owin;
using JSNLog;
using Microsoft.Owin;

[assembly: OwinStartup(typeof({{{Project}}}.Startup))]

namespace {{{Project}}}
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            app.UseJSNLog();
        }
    }
}

