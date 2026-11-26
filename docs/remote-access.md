# Remote access

## Tailscale

- Installed on the Proxmox host, which acts as a **subnet router** for the home subnet. Every service is reachable from my laptop and phone at its normal LAN address.
- IP forwarding is enabled on the host (`net.ipv4.ip_forward = 1`) and the route is approved in the Tailscale admin console.
- Windows clients need `tailscale set --accept-routes` to use the route.
- **Override DNS** in the Tailscale admin console is off. When it pointed every device at Pi-hole, a laptop that could not reach Pi-hole lost all internet as soon as Tailscale connected.

## Wake-on-LAN for the GPU PC

BIOS (ASUS, Advanced > APM): ErP Ready disabled, Power On By PCI-E enabled. In Windows: fast startup off, official Realtek driver, "Wake on Magic Packet" and "Shutdown Wake-On-Lan" enabled.

From the server, `wakepc` sends the magic packet. See [`scripts/pc-control.sh`](../scripts/pc-control.sh).

## Remote shutdown and sleep

The PC runs the Windows OpenSSH server, limited by Windows Firewall to the server's IP and to key login only. `shutpc` and `sleeppc` on the server run the Windows commands over SSH.
