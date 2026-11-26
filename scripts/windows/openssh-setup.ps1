# Run in an administrator PowerShell on the gaming PC.
# Lets the Proxmox host send sleep and shutdown commands over SSH.

Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType Automatic

# Only the server may connect
Set-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -RemoteAddress <server-ip>

# Paste the server's public key (cat ~/.ssh/id_ed25519.pub on the server)
Set-Content -Path C:\ProgramData\ssh\administrators_authorized_keys -Value "<server-public-key>"
icacls C:\ProgramData\ssh\administrators_authorized_keys /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F"

# Make sleep really sleep instead of hibernating
powercfg /h off
