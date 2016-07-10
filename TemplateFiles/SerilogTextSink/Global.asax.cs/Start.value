
// -----------------

string logFilePath = Path.Combine(Path.GetTempPath(), "log.txt");

var log = new LoggerConfiguration()
				.WriteTo.Sink(new FileSink(logFilePath, new RawFormatter(), null))
				.MinimumLevel.Verbose()
				.CreateLogger();

Log.Logger = log;
