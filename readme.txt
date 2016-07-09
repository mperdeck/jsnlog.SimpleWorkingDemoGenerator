
=============================
structure

* solution with empty projects. These are literally empty MVC projects. The required files will be filled in by the generator. Need to define these empty projects, because it isn't clear how to create a valid project inside a solution with a script.

* init script InitSolution.bat (calls InitSolution.ps1) Copies the empty solution to the jsnlogSimpleWorkingDemos directory and adds/modifies the required files. Note that this has to be done outside of Visual Studio, because adding/modifying files inside Visual Studio confuses it.

* install packages script that installs all required packages. Must be run inside Visual Studio Package Manager, so it can install packages.

==================================
templates

The files to be added/modified are in the templates directory:
C:\Dev\JSNLog\jsnlog.SimpleWorkingDemoGenerator\TemplateFiles

Under this directory are subdirs, one for each feature. These subdirs contain 2 types of files: 1) files to be copied to the sites and 2) values that are inserted after markers.

For example, the feature "Log4Net" contains all files and placeholder values required to make a project use Log4Net.
You may see a feature "Base". This is used for files that are common to all projects. 

About the 2 types of files:

1) Files not ending in .value: These get copied as is to the projects. They may contain markers, such as {{{LoggingPackageSpecific}}}. The .csproj file of the project is updated if needed to ensure the file is part of the project.

2) Files ending in .value: For example 
...\Base\Global.asax.cs\LoggingPackageSpecific.value

This file contains a value (one or more lines of text). Its directory matches the file to be updated. In this example, the value is inserted in ...project...\Global.asax.cs after the marker {{{LoggingPackageSpecific}}}.

{{{Project}}} is special. It is always replaced by the project name. So it is not a marker as described above.

Note that at the end of the replacement process, all markers will be removed.


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














