#
# BuildHelpers.ps1
#

# $slnDir - dir containing the .sln file
Function BuildSolution([string] $slnDir)
{
	cmd /c "cd $slnDir; msbuild"
}
