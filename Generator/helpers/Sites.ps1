#
# Sites.ps1
#

# features is any features in addition to "Base" and loggingPackage (so "NLog" is a feature itself)
# likewise, packages is any packages in addition to those needed for the logging package (such as 'Log4Net" and "JSNLog.Log4Net")
# removeRegexes has zero or more regexes. After package installation, any string in web.config that matches any of these regexes is removed.
# expectedStrings - all the strings that are expected to be in the log file after a GET request to the file. If empty or non existent, the site does not write a log file (eg. it writes to MongoDb).
# notexpectedStrings - all the strings that are expected to be not in the log file after a GET request to the file. If empty or non existent, this is not checked.

$standardExpectedStringsWithoutOnError = @(
	"info server log message", `
    "debug client log message", `
    "info client log message", `
    "warn client log message - logging object", `
    "error client log message - returned by function", `
    "fatal client log message", `
	 "Something went wrong!", `
	 "xyz is not defined"
)

$standardExpectedStrings = $standardExpectedStringsWithoutOnError + @("Uncaught Exception", "xyz2 is not defined")

$fatalOnlyExpectedStrings = @(
	"info server log message", `
    "fatal client log message", `
	 "Something went wrong!", `
	 "xyz is not defined", `
	 "xyz2 is not defined"
)

$decycleExpectedStrings = @(
	'{"x":1,"c":{"$ref":"$"}}', `
    '{"x":1,"c":{"b":{"y":2,"d":{"e":{"$ref":"$"}}}}}'
)

$unhandledRejectionExpectedStrings = @(
    'Exception thrown in promise'
)

$sites = @(
	[pscustomobject]@{base="BaseCore"; isCore=$true; projectName="JSNLogDemo_Core_Net4x"; features=@("Net4x"); removeRegexes=@(); expectedStrings=$standardExpectedStrings },
	[pscustomobject]@{base="BaseCore"; isCore=$true; projectName="JSNLogDemo_Core_NetCoreApp2"; features=@("NetCoreApp2"); removeRegexes=@(); expectedStrings=$standardExpectedStrings },
	[pscustomobject]@{projectName="JSNLogDemo_Serilog"; loggingPackage="Serilog"; features=@("SerilogTextSink"); packages=@("Serilog.Sinks.File"); removeRegexes=@(); expectedStrings=$standardExpectedStrings },
	[pscustomobject]@{projectName="JSNLogDemo_Serilog_MongoDB"; loggingPackage="Serilog"; features=@("SerilogMongoDBSink"); packages=@("Serilog.Sinks.MongoDB"); removeRegexes=@() },
	[pscustomobject]@{projectName="JSNLogDemo_Elmah"; loggingPackage="Elmah"; features=@(); packages=@(); removeRegexes=@(); expectedStrings=$standardExpectedStrings },
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net"; loggingPackage="Log4Net"; features=@(); packages=@(); removeRegexes=@(); expectedStrings=$standardExpectedStrings },
	
	# Note that here we test beforeSend, X-FORWARD-FOR header and Configure In Code (the last is needed to get JSNLog to log the IP addresses of the sender)
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net_beforeSend"; loggingPackage="Log4Net"; features=@("beforeSend", "ConfigurationInCode"); packages=@(); removeRegexes=@("<jsnlog.*?>", "</jsnlog>"); expectedStrings=$fatalOnlyExpectedStrings + @("99.88.77.66") },

	# Note that for this site we test JSNLog.CommonLogging package
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net_ConfigurationInCode"; features=@("Log4Net", "CommonLoggingLog4Net", "ConfigurationInCode"); packages=@("Log4Net", "JSNLog.CommonLogging", "Common.Logging.Log4Net.Universal"); removeRegexes=@("<jsnlog.*?>", "</jsnlog>"); expectedStrings=$fatalOnlyExpectedStrings },
	
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net_CORS"; loggingPackage="Log4Net"; features=@("CORS"); packages=@(); removeRegexes=@("<jsnlog.*?>", "</jsnlog>"); expectedStrings=$standardExpectedStrings },
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net_LoggingEventHandlers"; loggingPackage="Log4Net"; features=@("LoggingEventHandlers"); packages=@(); removeRegexes=@(); expectedStrings=$standardExpectedStrings; notexpectedStrings=@("fatal client log message - this will be suppressed by logging event handler") },
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net_OWIN"; loggingPackage="Log4Net"; features=@("OWIN"); packages=@("Microsoft.Owin.Host.SystemWeb"); removeRegexes=@("<add name=`"LoggerHandler`".*?>", "<add name=`"LoggerHandler-Classic`".*?>"); expectedStrings=$standardExpectedStrings },
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net_RequestIds"; loggingPackage="Log4Net"; features=@("RequestIds"); packages=@(); removeRegexes=@(); expectedStrings=$standardExpectedStrings },
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net_Decycle"; loggingPackage="Log4Net"; features=@("Decycle"); packages=@(); removeRegexes=@(); expectedStrings=$standardExpectedStrings+$decycleExpectedStrings },
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net_UnhandledRejection"; loggingPackage="Log4Net"; features=@("UnhandledRejection"); packages=@(); removeRegexes=@(); expectedStrings=$standardExpectedStrings+$unhandledRejectionExpectedStrings },
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net_NoOnErrorHandler"; loggingPackage="Log4Net"; features=@("NoOnErrorHandler"); packages=@(); removeRegexes=@(); expectedStrings=$standardExpectedStringsWithoutOnError; notexpectedStrings=@("xyz2") },
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net_CustomOnErrorHandler"; loggingPackage="Log4Net"; features=@("CustomOnErrorHandler"); packages=@(); removeRegexes=@(); expectedStrings=$standardExpectedStringsWithoutOnError + $("Custom message") },
	[pscustomobject]@{projectName="JSNLogDemo_NLog"; loggingPackage="NLog"; features=@(); packages=@(); removeRegexes=@(); expectedStrings=$standardExpectedStrings }
)
