Function Add-FrameworkTypes([switch]$WPF, [switch]$Forms, [switch]$All)
{
    # Add WPF for GUI
    if($WPF -or $All){
        Add-Type -AssemblyName PresentationFramework
    }

    # Add Windows Forms for Open File Dialog
    if($Forms -or $All){
        Add-Type -AssemblyName System.Windows.Forms
    }

    # Add hiding/showing the console
    Add-Type -Name Window -Namespace Console -MemberDefinition '
    [DllImport("Kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
    '
}

Function Initialize-Gui([string]$xml, [switch]$WPF, [switch]$Forms, [switch]$All, [switch]$Show, [switch]$Hide){
    # Add WPF and Window Forms frameworks 
    if($WPF){
        Add-FrameworkTypes -WPF
    }
    elseif($Forms){
        Add-FrameworkTypes -Forms
    }
    else{
        Add-FrameworkTypes -All
    }
    
    # Get xml content for GUI
    [xml]$XAML = Get-Content $xml

    # Initialize the GUI
    $reader = (New-Object System.Xml.XmlNodeReader $XAML)
    $gui = [Windows.Markup.XamlReader]::Load($reader)

    #Create hooks to each named object in the XAML

    $XAML.SelectNodes("//*[@Name]") | %{

        Set-Variable -Name ($_.Name) -Value $gui.FindName($_.Name) -Scope Global

    }

    # Hide or show Console
    if($Show){
        $gui.Add_ContentRendered({
            Show-Console
        })
    }
    else{
        $gui.Add_ContentRendered({
            Hide-Console
        })
    }

    return $gui
}

# Function for Open File Browser
Function Get-File([string]$Filter,[string]$InitialDirectory = $PSScriptRoot){
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
        InitialDirectory = $InitialDirectory #[Environment]::GetFolderPath('MyComputer')
        Filter = $Filter
    }
    $result = $FileBrowser.ShowDialog()

    if($result -eq "OK"){
        return $FileBrowser.FileName
    }
    else{
        return $null
    }
}

# Method for showing Console
Function Show-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()

    # Hide = 0,
    # ShowNormal = 1,
    # ShowMinimized = 2,
    # ShowMaximized = 3,
    # Maximize = 3,
    # ShowNormalNoActivate = 4,
    # Show = 5,
    # Minimize = 6,
    # ShowMinNoActivate = 7,
    # ShowNoActivate = 8,
    # Restore = 9,
    # ShowDefault = 10,
    # ForceMinimized = 11

    [Console.Window]::ShowWindow($consolePtr, 4)
}

# Method for hiding Console
Function Hide-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()
    #0 hide
    [Console.Window]::ShowWindow($consolePtr, 0)
}

Export-ModuleMember -Function Add-FrameworkTypes
Export-ModuleMember -Function Initialize-Gui
Export-ModuleMember -Function Get-File
Export-ModuleMember -Function Show-Console
Export-ModuleMember -Function Hide-Console