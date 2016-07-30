#
# Sites.ps1
#

# features is any features in addition to "Base" and loggingPackage (so "NLog" is a feature itself)
# likewise, packages is any packages in addition to those needed for the logging package (such as 'Log4Net" and "JSNLog.Log4Net")
# removeRegexes has zero or more regexes. After package installation, any string in web.config that matches any of these regexes is removed.
# expectedStrings - all the strings that are expected to be in the log file after a GET request to the file. If empty or non existent, the site does not write a log file (eg. it writes to MongoDb).

$standardExpectedStringsWithoutOnError = @(
	"info server log message", `
    "debug client log message", `
    "info client log message", `
    "warn client log message - logging object", `
    "error client log message - returned by function", `
    "fatal client log message", `
	 "Exception!", `
	 "Something went wrong!", `
	 "xyz is not defined"
)

$standardExpectedStrings = $standardExpectedStringsWithoutOnError + @("xyz2 is not defined")

$fatalOnlyExpectedStrings = @(
	"info server log message", `
    "fatal client log message", `
	 "Exception!", `
	 "Something went wrong!", `
	 "xyz is not defined", `
	 "xyz2 is not defined"
)

$sites = @(
	[pscustomobject]@{projectName="JSNLogDemo_Serilog"; loggingPackage="Serilog"; features=@("SerilogTextSink"); packages=@("Serilog.Sinks.File"); removeRegexes=@(); expectedStrings=$standardExpectedStrings },
	[pscustomobject]@{projectName="JSNLogDemo_Serilog_MongoDB"; loggingPackage="Serilog"; features=@("SerilogMongoDBSink"); packages=@("Serilog.Sinks.MongoDB"); removeRegexes=@() },
	[pscustomobject]@{projectName="JSNLogDemo_Elmah"; loggingPackage="Elmah"; features=@(); packages=@(); removeRegexes=@(); expectedStrings=$standardExpectedStrings },
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net"; loggingPackage="Log4Net"; features=@(); packages=@(); removeRegexes=@(); expectedStrings=$standardExpectedStrings },
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net_beforeSend"; loggingPackage="Log4Net"; features=@("beforeSend"); packages=@(); removeRegexes=@(); expectedStrings=$standardExpectedStrings },

	# Note that for this site we test JSNLog.CommonLogging package
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net_ConfigurationInCode"; features=@("Log4Net", "CommonLoggingLog4Net", "ConfigurationInCode"); packages=@("Log4Net", "JSNLog.CommonLogging", "Common.Logging.Log4Net1215"); removeRegexes=@("<jsnlog.*?>", "</jsnlog>"); expectedStrings=$fatalOnlyExpectedStrings },
	
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net_CORS"; loggingPackage="Log4Net"; features=@("CORS"); packages=@(); removeRegexes=@("<jsnlog.*?>", "</jsnlog>"); expectedStrings=$standardExpectedStrings },
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net_LoggingEventHandlers"; loggingPackage="Log4Net"; features=@("LoggingEventHandlers"); packages=@(); removeRegexes=@(); expectedStrings=$standardExpectedStrings },
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net_OWIN"; loggingPackage="Log4Net"; features=@("OWIN"); packages=@("Microsoft.Owin.Host.SystemWeb"); removeRegexes=@("<add name=`"LoggerHandler`".*?>", "<add name=`"LoggerHandler-Classic`".*?>"); expectedStrings=$standardExpectedStrings },
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net_RequestIds"; loggingPackage="Log4Net"; features=@("RequestIds"); packages=@(); removeRegexes=@(); expectedStrings=$standardExpectedStrings },
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net_RequestIds"; loggingPackage="Log4Net"; features=@("RequestIds"); packages=@(); removeRegexes=@(); expectedStrings=$standardExpectedStrings },
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net_NoOnErrorHandler"; loggingPackage="Log4Net"; features=@("NoOnErrorHandler"); packages=@(); removeRegexes=@(); expectedStrings=$standardExpectedStringsWithoutOnError },
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net_CustomOnErrorHandler"; loggingPackage="Log4Net"; features=@("CustomOnErrorHandler"); packages=@(); removeRegexes=@(); expectedStrings=$standardExpectedStrings },
	[pscustomobject]@{projectName="JSNLogDemo_NLog"; loggingPackage="NLog"; features=@(); packages=@(); removeRegexes=@(); expectedStrings=$standardExpectedStrings }
)
