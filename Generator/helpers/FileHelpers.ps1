#
# FileHelpers.ps1
#

$TemplateRootDir = "C:\Dev\JSNLog\jsnlog.SimpleWorkingDemoGenerator\TemplateFiles"
$ProjectsRootDir = "C:\Dev\JSNLog\jsnlogSimpleWorkingDemos\jsnlogSimpleWorkingDemos"
$SolutionPath = "$ProjectsRootDir\jsnlogSimpleWorkingDemos.sln"
$EmptySolutionRootDir = "C:\Dev\JSNLog\jsnlog.SimpleWorkingDemoGenerator\EmptySolution\jsnlogSimpleWorkingDemos"

Function RemoveDirectory([string] $path)
{
	cmd /c "rd /s /q $path"
}

Function CopyDirectory([string] $fromPath, [string] $toPath)
{
	if (Test-Path -path $toPath) { RemoveDirectory $toPath }
	New-Item $toPath -itemtype directory -force
	copy-item "$fromPath\*" $toPath -force -recurse -verbose
}

Function CopyEmptySolution()
{
	CopyDirectory $EmptySolutionRootDir $ProjectsRootDir
}

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

# Returns the absolute path of a feature directory within the templates directory
Function FeatureDirPath([string] $feature)
{
	$path = Join-Path $TemplateRootDir $feature
	Return $path
}

# Returns the absolute path of a project directory within the jsnlogSimpleWorkingDemos directory
Function ProjectDirPath([string] $projectName)
{
	$path = Join-Path $ProjectsRootDir $projectName
	Return $path
}

# Returns the absolute path to a file that lives within a project, given
# the project and the file's relative path within the project directory.
Function ProjectFilePath([string] $projectName, [string] $projectFileRelPath)
{
	$projectDirPath = ProjectDirPath $projectName
	$path = Join-Path $projectDirPath $projectFileRelPath
	Return $path
}

Function ToMarker([string] $markerName)
{
	Return "{{{$markerName}}}"
}

# Inserts $value into a project file, right after the marker with the given name
Function InsertValueInProjectFile([string] $value, [string] $markerName, [string] $projectName, [string] $projectFileRelPath)
{
	$projectFilePath = ProjectFilePath $projectName $projectFileRelPath
	$content = [IO.File]::ReadAllText($projectFilePath)

	$marker = ToMarker $markerName
	$content = $content -replace $marker, "$marker`n$value"

	$content | Out-File -encoding ascii $projectFilePath
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

# Copies a file to a project within the jsnlogSimpleWorkingDemos site
# $projectFileRelPath is relative, within the project dir.
Function CopyFileToProject([string] $absoluteSourcePath, [string] $projectName, [string] $projectFileRelPath)
{
	$absoluteProjectFilePath = ProjectFilePath $projectName $projectFileRelPath

	if (-not (Test-Path $absoluteProjectFilePath))
	{
		AddFileToCSProj $projectName $projectFileRelPath
	}

	$content = [IO.File]::ReadAllText($absoluteSourcePath)
	$newContent = $content.replace("{{{Project}}}", $projectName)
	$newContent | Out-File -encoding ascii $absoluteProjectFilePath
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

# In the given file, remove all strings that match the given regex.
Function RemoveRegexInFile([string] $regex, [string] $path)
{
	$content = [IO.File]::ReadAllText($path)

	# replace without 2nd argument removes the matched strings
	$content = $content -replace $regex 

	$content | Out-File -encoding ascii $path
}

Function CopyMainFile([string] $projectName, [string] $logPackage, [string] $siteFileRelPath, [string] $siteFileRelPathUsing)
{
	$basePath = "Base\$siteFileRelPath"
	$content = TemplateFileContents $basePath

	$newContent = $content.replace("{{{Project}}}", $projectName)

	$replacerTemplateFileRelPath = "$logPackage\$siteFileRelPath"
	$newContent2 = ReplacePlaceholderByTemplateFile $newContent "{{LoggingPackageSpecific}}" $replacerTemplateFileRelPath

	$replacerTemplateFileRelPathUsing = "$logPackage\$siteFileRelPathUsing"
	$newContent3 = ReplacePlaceholderByTemplateFile $newContent2 "{{LoggingPackageSpecificUsing}}" $replacerTemplateFileRelPathUsing

	AddSiteFile $newContent3 $projectName $siteFileRelPath
}

# Copies the HomeController, Home/index.cstml, Global.asax and Web.config files
# Does replacements for the logPackage, etc.
Function CopyMainFiles([string] $projectName, [string] $logPackage)
{
	CopyMainFile $projectName $logPackage "Views\Home\Index.cshtml"
	CopyMainFile $projectName $logPackage "Global.asax.cs" "Global_Using.asax.cs"
	CopyMainFile $projectName $logPackage "Controllers\HomeController.cs" "Controllers\HomeController_Using.cs"
	CopyMainFile $projectName $logPackage "Web.config"
}


# $featureFilePath is the path to a file within the template directory.
# This file will be copied to the given project.
Function ApplyFeatureFileToProject([string] $projectName, [string] $feature, [string] $featureFilePath)
{
	$featureDir = FeatureDirPath $feature
	$projectFileRelPath = $featureFilePath.replace($featureDir, "")

	CopyFileToProject $featureFilePath $projectName $projectFileRelPath
}

# $featureValueFilePath is an absolute path of a value file (ends in .value) that lives in the templates dir.
# Its path looks like this:
# ..../xyz.cs/abc.value
# ..../xyz.cs is obviously a directory inside the template dir. But it matches a file that lives within a
# project within jsnlogSimpleWorkingDemos. 
#
# Within that project file, there may be a marker with the same name as the value file.
# For example, {{{abc}}}
# The contents of the value file is inserted in the project file, right after marker.
# The marker is not replaced - that way, multiple value files of multiple features can use that one marker.
# 
Function ApplyFeatureValueFileToProject([string] $projectName, [string] $feature, [string] $featureValueFilePath)
{
	$featureDir = FeatureDirPath $feature

	$value = [IO.File]::ReadAllText($featureValueFilePath) 
	$markerName = [System.IO.Path]::GetFileNameWithoutExtension($featureValueFilePath)

	$featureValueFileDir = Split-Path $featureValueFilePath
	$projectFileRelPath = $featureValueFileDir -replace $featureDir

	InsertValueInProjectFile $value $markerName $projectName $projectFileRelPath
}

# Removes all markers from a file. Markers are {{{...markertext...}}}
Function RemoveMarkersFromFile([string] $path)
{
	# inside the {{{ }}}, do a non-greedy match, otherwise all text between first and last marker gets removed.
	$regex = "{{{.*?}}}"
	RemoveRegexInFile $regex $path
}

Function ApplyFeatureToProject([string] $projectName, [string] $feature)
{
	# A feature directory is a directory for a feature that sits under the template dir.
	$featureDir = FeatureDirPath $feature

	# First copy all normal files
	get-childitem $featureDir -recurse -force | `
		?{($_.extension -ne ".value")} | `
		ForEach-Object { ApplyFeatureFileToProject $projectName $feature $_.FullName }

	# Then insert values at markers in the files.
	# Take the file ....\xyz.cs\logger.value
	# The value of this file will be inserted in ....\xyz.cs, below the {{{logger}}} marker.
	get-childitem $featureDir -recurse -force | `
		?{($_.extension -eq ".value")} | `
		ForEach-Object { ApplyFeatureValueFileToProject $projectName $feature $_.FullName }
}
	
Function RemoveMarkersFromProject([string] $projectName)
{
	$projectDir = ProjectDirPath $projectName

	get-childitem $projectDir -recurse -force | `
		?{($_.extension -eq ".cs") -or ($_.extension -eq ".cshtml") -or ($_.extension -eq ".config")} | `
		ForEach-Object { RemoveMarkersFromFile $_.FullName }
}

