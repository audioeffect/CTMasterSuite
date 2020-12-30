function Out-Message{
    Param(
        [string]$Message,
        [string]$LogPath = $LogFile,
        [switch]$NoTimestamp,
        [switch]$NoAppend,
        [switch]$LogOnly
    )

    if(!$NoTimestamp){
        if(!$LogOnly){
            if(!$NoAppend){
                Write-Output ("{0} - {1}" -f (Get-Date), $Message) | Tee-Object $LogPath -Append
            } else {
                Write-Output ("{0} - {1}" -f (Get-Date), $Message) | Tee-Object $LogPath
            }
        } else {
            if(!$NoAppend){
                Write-Output ("{0} - {1}" -f (Get-Date), $Message) | Out-File $LogPath -Append
            } else {
                Write-Output ("{0} - {1}" -f (Get-Date), $Message) | Out-File $LogPath
            }
        }
    } else {
        if(!$LogOnly){
            if(!$NoAppend){
                Write-Output ("{0}" -f $Message) | Tee-Object $LogPath -Append
            } else {
                Write-Output ("{0}" -f $Message) | Tee-Object $LogPath
            }
        } else {
            if(!$NoAppend){
                Write-Output ("{0}" -f $Message) | Out-File $LogPath -Append
            } else {
                Write-Output ("{0}" -f $Message) | Out-File $LogPath
            }
        }
    }
}

Export-ModuleMember -Function Out-Message