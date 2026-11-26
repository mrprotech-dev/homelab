# Run in an administrator PowerShell on the gaming PC after installing Ollama.

# Listen on the network, not just 127.0.0.1 (permanent, system-wide)
setx OLLAMA_HOST "0.0.0.0" /M

# Allow only the home network to reach Ollama, on the Private profile
New-NetFirewallRule -DisplayName "Ollama" -Direction Inbound -Protocol TCP -LocalPort 11434 `
  -RemoteAddress <home-subnet>/24 -Action Allow -Profile Private

# Restart Ollama so it picks up the new setting
Get-Process ollama* -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Process "$env:LOCALAPPDATA\Programs\Ollama\ollama app.exe"

# A model that fits fully in 12 GB of VRAM
ollama pull qwen3.5:9b
