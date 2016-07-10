#
# Sites.ps1
#

# features is any features in addition to "Base" and loggingPackage (so "NLog" is a feature itself)
# likewise, packages is any packages in addition to those needed for the logging package (such as 'Log4Net" and "JSNLog.Log4Net")
$sites = @(
	[pscustomobject]@{projectName="JSNLogDemo_Serilog"; loggingPackage="Serilog"; features=@(); packages=@() },
	[pscustomobject]@{projectName="JSNLogDemo_Elmah"; loggingPackage="Elmah"; features=@(); packages=@() },
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net"; loggingPackage="Log4Net"; features=@(); packages=@() },
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net_beforeSend"; loggingPackage="Log4Net"; features=@("beforeSend"); packages=@() },
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net_ConfigurationInCode"; loggingPackage="Log4Net"; features=@("ConfigurationInCode"); packages=@() },
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net_CORS"; loggingPackage="Log4Net"; features=@("CORS"); packages=@() },
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net_LoggingEventHandlers"; loggingPackage="Log4Net"; features=@("LoggingEventHandlers"); packages=@() },
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net_OWIN"; loggingPackage="Log4Net"; features=@("OWIN"); packages=@() },
	[pscustomobject]@{projectName="JSNLogDemo_NLog"; loggingPackage="NLog"; features=@(); packages=@() }
)
