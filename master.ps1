Param(
    [String]$MasterPath = $PSScriptRoot
)

# Move location to script root
Push-Location $MasterPath

# Import module and run script elevated
if(!$Elevated){
    Import-Module  "\\tsupport\tsupload\Cole\PS\Modules\Restart-Elevated.psm1"
    Restart-Elevated -PassedCommand $PSCommandPath -PassedParam $PSBoundParameters
}

# Import all modules in the module folder
Get-ChildItem .\modules | % {
    Import-Module $_.FullName
}

# Create GUI
$window = Initialize-Gui .\xml\window.xaml

Get-Variable
pause

# Get XAML variables
#$ScriptPicker = $window.FindName("ScriptPicker")
#$ScriptBrowser = $window.FindName("ScriptBrowser")

# Show GUI
$null = $window.ShowDialog()