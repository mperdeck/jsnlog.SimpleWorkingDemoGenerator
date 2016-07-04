
rem Removes the current simple working demos, and copies the empty solution in their place.
rem Afterwards, open the copied empty solution in VS and run the Generate.ps1 script inside the Package Manager Console

cd C:\Dev\JSNLog\jsnlogSimpleWorkingDemos

rem Remove existing directory
rmdir /s /q jsnlogSimpleWorkingDemos
mkdir jsnlogSimpleWorkingDemos

rem Copy empty solution
xcopy /s /e /q C:\Dev\JSNLog\jsnlog.SimpleWorkingDemoGenerator\EmptySolution\jsnlogSimpleWorkingDemos\*.* jsnlogSimpleWorkingDemos

rem Start Visual Studio
rem devenv lives in C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE
devenv C:\Dev\JSNLog\jsnlogSimpleWorkingDemos\jsnlogSimpleWorkingDemos\jsnlogSimpleWorkingDemos.sln




