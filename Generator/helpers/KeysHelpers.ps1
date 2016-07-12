#
# KeysHelper.ps1
#

Function SendKey([string] $keys)
{
	Add-Type -AssemblyName System.Windows.Forms
	[System.Windows.Forms.SendKeys]::SendWait($keys);
}


