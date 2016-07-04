#
# FileHelpers.ps1
#

$TemplateRootDir = "C:\Dev\JSNLog\jsnlog.SimpleWorkingDemoGenerator\TemplateFiles"
$ProjectsRootDir = "C:\Dev\JSNLog\jsnlogSimpleWorkingDemos\jsnlogSimpleWorkingDemos"

# Returns the absolute path of a file within a project
Function SiteFilePath([string] $projectName, [string] $siteFileRelPath)
{
	$relPath = Join-Path $projectName $siteFileRelPath
	$path = Join-Path $ProjectsRootDir $relPath
	Return $path
}

# Returns the absolute path of a file within the templates
Function TemplateFilePath([string] $templateFileRelPath)
{
	$path = Join-Path $TemplateRootDir $templateFileRelPath
	Return $path
}

# Reads a template file and returns its contents.
# Takes a path relative to the root of the template directory.
Function TemplateFileContents([string] $templateFileRelPath)
{
	$path = TemplateFilePath $templateFileRelPath
	$content = [IO.File]::ReadAllText($path)
	Return $content
}

Function EnsureDirectoryExists([string] $path)
{
	$directory = Split-Path -Path $path
	New-Item -ItemType Directory -Force -Path $directory
}

# Writes the given content to a file in a site (represented by a project).
# If the file exists, it is overwritten.
# $siteFileRelPath is the relative path of the file, relative to the root of the project.
Function UpdateSiteFile([string] $content, [string] $projectName, [string] $siteFileRelPath)
{
	$path = SiteFilePath $projectName $siteFileRelPath
	EnsureDirectoryExists $path
	$content | Out-File -encoding ascii $path
}

# Adds a file to the .csproj of a project
# $siteFileRelPath is the relative path of the file, relative to the root of the project.
Function AddFileToCSProj([string] $projectName, [string] $siteFileRelPath)
{
	$marker = '<Content Include="Web.config" />'

	$csProjPath = SiteFilePath $projectName "$projectName.csproj"
	$csProjContent = [IO.File]::ReadAllText($csProjPath)

	$newEntry = "<Content Include=""$siteFileRelPath"" />"
	if ($siteFileRelPath.EndsWith(".cs"))
	{
		$newEntry = "<Compile Include=""$siteFileRelPath"" />"
	}

	$csProjNewContent = $csProjContent.replace($marker, "$marker$newEntry")

	$csProjNewContent | Out-File -encoding ascii $csProjPath
}

# Writes the given content to a file in a site (represented by a project).
# If the file exists, it is overwritten.
# $siteFileRelPath is the relative path of the file, relative to the root of the project.
#
# If the file didn't already exist, it is added to the .csproj file as well.
Function AddSiteFile([string] $content, [string] $projectName, [string] $siteFileRelPath)
{
	$path = SiteFilePath $projectName $siteFileRelPath
	if (-not (Test-Path $path))
	{
		AddFileToCSProj $projectName $siteFileRelPath
	}

	UpdateSiteFile $content $projectName $siteFileRelPath
}

# In $content, replaces a place holder by the contents of a template file.
# If that template file does not exist, the place holder is simply removed.
# Returns the new content.
Function ReplacePlaceholderByTemplateFile([string] $content, [string] $placeHolderName, [string] $templateFileRelPath)
{
	$replacementText = ""
	$path = TemplateFilePath $templateFileRelPath
	if (Test-Path $path)
	{
		$replacementText = TemplateFileContents $templateFileRelPath
	}

	$newContent = $content.replace($placeHolderName, $replacementText)
	Return $newContent
}

Function CopyMainFile([string] $projectName, [string] $logPackage, [string] $siteFileRelPath)
{
	$basePath = "Base\$siteFileRelPath"
	$content = TemplateFileContents $basePath

	$newContent = $content.replace("{{Project}}", $projectName)

	$replacerTemplateFileRelPath = "$logPackage\$siteFileRelPath"
	$newContent2 = ReplacePlaceholderByTemplateFile $newContent "{{LoggingPackageSpecific}}" $replacerTemplateFileRelPath

	AddSiteFile $newContent2 $projectName $siteFileRelPath
}

# Copies the HomeController, Home/index.cstml, Global.asax and Web.config files
# Does replacements for the logPackage, etc.
Function CopyMainFiles([string] $projectName, [string] $logPackage)
{
	CopyMainFile $projectName $logPackage "Views\Home\Index.cshtml"
	CopyMainFile $projectName $logPackage "Global.asax.cs"
	CopyMainFile $projectName $logPackage "Controllers\HomeController.cs"
	CopyMainFile $projectName $logPackage "Web.config"
}

