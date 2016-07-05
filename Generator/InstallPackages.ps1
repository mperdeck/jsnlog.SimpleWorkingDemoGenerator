
. "$PSScriptRoot\helpers\FileHelpers.ps1"
. "$PSScriptRoot\helpers\NugetHelpers.ps1"
. "$PSScriptRoot\helpers\Sites.ps1"

foreach ($site in $Sites)
{
  InstallMainPackage $site.projectName $site.logPackage
}


