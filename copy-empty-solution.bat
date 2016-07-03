
rem Removes the current simple working demos, and copies the empty solution in their place.
rem Afterwards, open the copied empty solution in VS and run the Generate.ps1 script inside the Package Manager Console

cd C:\Dev\JSNLog

rem Copy .git directory to temp dir
mkdir %temp%\simple\.git
del /s /q %temp%\simple\*.* 
del /s /q /ah %temp%\simple\*.* 
xcopy /s /e /q /h jsnlogSimpleWorkingDemos\.git\*.* %temp%\simple\.git

rem Remove contents of simple working demo dir
del /s /q jsnlogSimpleWorkingDemos\*.* 
del /s /q /ah jsnlogSimpleWorkingDemos\*.* 
rmdir /s /q jsnlogSimpleWorkingDemos

rem Copy empty solution
xcopy /s /e /q C:\Dev\JSNLog\jsnlog.SimpleWorkingDemoGenerator\EmptySolution\jsnlogSimpleWorkingDemos\*.* jsnlogSimpleWorkingDemos

rem Copy .git dir back in
mkdir jsnlogSimpleWorkingDemos\.git
xcopy /s /e /q /h /y %temp%\simple\.git jsnlogSimpleWorkingDemos\.git\*.*

rem Start Visual Studio
rem devenv lives in C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE
devenv C:\Dev\JSNLog\jsnlogSimpleWorkingDemos\jsnlogSimpleWorkingDemos.sln




