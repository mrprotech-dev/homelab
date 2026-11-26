#!/usr/bin/env bash
# Shortcuts for controlling the gaming PC from the Proxmox host.
# Add to ~/.bashrc with: source /path/to/pc-control.sh
# Needs: apt install wakeonlan, and an SSH key trusted by the PC's OpenSSH server.

PC_MAC="<pc-mac-address>"     # e.g. aa:bb:cc:dd:ee:ff
PC_IP="<pc-ip>"
PC_USER="<windows-username>"

wakepc()  { wakeonlan -i <broadcast-address> "$PC_MAC"; }
sleeppc() { ssh "$PC_USER@$PC_IP" 'rundll32.exe powrprof.dll,SetSuspendState 0,1,0'; }
shutpc()  { ssh "$PC_USER@$PC_IP" 'shutdown /s /t 0'; }
