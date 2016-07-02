
=============================
structure

* solution with empty projects. The empty projects have all the required files (such as HomeController.cs), but these are empty and will be replaced by generator script.
* nuget package. Used to build a new demo project.
* generator script. Must be run from inside the Visual Studio Package Manager, so it can install packages.

==================================
Adding a new demo

-------------------
1) Create empty project

Open 
C:\Dev\JSNLog\jsnlog.SimpleWorkingDemoGenerator\EmptySolution\jsnlogSimpleWorkingDemos\jsnlogSimpleWorkingDemos.sln

Add a new project to the solution 

Scaffold:
ASP.NET Web Application

Name:
name of your demo project

location:
C:\Dev\JSNLog\jsnlog.SimpleWorkingDemoGenerator\EmptySolution\jsnlogSimpleWorkingDemos

under
ASP.NET 4.5.1 Templates

click
Empty

check
MVC

Save All to save the solution file, and the new project.

-------------------
2) Add basic files

Make sure this is one of the nuget package sources:
C:\Dev\JSNLog\jsnlog.SimpleWorkingDemoGenerator\InitPackages\GeneratedPackages

install-package initproject


