
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
name of your demo project. Note that - is not allowed in the name. Use _

location:
C:\Dev\JSNLog\jsnlog.SimpleWorkingDemoGenerator\EmptySolution\jsnlogSimpleWorkingDemos

under
ASP.NET 4.5.1 Templates

click
Empty

check
MVC

Save All to save the solution file, and the new project.

=================================
To regenerate the demos repo

0) >>>> run publish.ps1 to generate the new jsnlog packages in 
C:\Dev\@NuGet\GeneratedPackages

1) Copy the empty solution over the demos. Run
C:\Dev\JSNLog\jsnlog.SimpleWorkingDemoGenerator\Generator\InitSolution.bat

This also opens VS with the demos solution.
C:\Dev\JSNLog\jsnlogSimpleWorkingDemos\jsnlogSimpleWorkingDemos.sln

2)
In Package Manager Console, run:
C:\Dev\JSNLog\jsnlog.SimpleWorkingDemoGenerator\Generator\InstallPackages.ps1














