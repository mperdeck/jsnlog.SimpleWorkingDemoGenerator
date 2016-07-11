#
# BuildHelpers.ps1
#

# $slnDir - dir containing the .sln file
Function BuildSolution([string] $slnDir)
{
	Write-Host "Building $slnDir"
	cmd /c "cd $slnDir & msbuild"
}
