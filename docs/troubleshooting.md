# Troubleshooting log

Real problems I hit while building the lab, what caused them and how I fixed them.

| Problem | Cause | Fix |
| --- | --- | --- |
| Whole server dropped off the network at random | Known hang in the Intel e1000e driver under load | Turned off TCP/generic offloads with a `post-up ethtool -K nic0 tso off gso off gro off` line; later replaced the port with a 2.5 GbE card |
| Server froze after moving to NVMe | NVMe drive misbehaving in deep power-saving states (APST) | Added `nvme_core.default_ps_max_latency_us=0` to the kernel command line |
| Homepage build killed (SIGKILL) | Build needs more than 1 GB RAM | Raised the container to 4 GB for the build, then back to 1 GB |
| Homepage showed a YAML error | A Windows path in a description contained a colon | Quoted the description string |
| Open WebUI could not reach Ollama | A corporate VPN client's network filter on the PC, then later Ollama listening only on 127.0.0.1 | Removed the VPN client; set `OLLAMA_HOST=0.0.0.0` as a system variable |
| 30B model stalled for minutes | Model larger than VRAM plus thinking output overflowing a 4096-token context | Used a model that fits in 12 GB VRAM, raised context, used `/no_think` |
| Sandbox VM had no internet | Firewall blocked the router, which the VM also used for DNS | Added an allow rule for the router on port 53 |
| xrdp black screen and errors | Missing session packages for the desktop | Switched to Ubuntu's built-in Remote Login and SPICE |
| VM would not start, "missing libraries" | VirGL display needs GL libraries on the host | `apt install libgl1 libegl1` |
| Backup run from the web shell died | Closing the browser shell ends its processes | Ran backups as Proxmox GUI tasks instead |
| Restored VM came back with the wrong ID | Restore defaulted to the next free ID | Removed it and restored again with the original ID |
| SSH warning after reinstall | New host key after reinstalling Proxmox | Checked the fingerprint on the console, then `ssh-keygen -R` |
| Fast share missing after migration | Its Samba section had not been restored | Re-added it and checked with `testparm` |
| PC woke from sleep but not from shutdown | Generic Windows network driver after a reset | Installed the official Realtek driver and enabled shutdown wake |
| Internet "down" with the router still on | DNS depended on Pi-hole; router forwarded all DNS as one client | Router now hands out Pi-hole directly; host uses its own DNS |
| Tailscale broke all internet on the laptop | Tailscale DNS override pointed at Pi-hole, which was unreachable | Turned off DNS override |
| Services unreachable through Tailscale | Subnet route not advertised after the NVMe reinstall | Re-enabled IP forwarding, advertised the route, approved it |
| Mapped drives would not reconnect | Stale mappings, and mappings made in an admin shell are invisible to Explorer | Removed old mappings and remapped in a normal session |
| USB SSD enclosure dropped mid-copy | Faulty enclosure and USB-A adapter (SSD SMART data clean) | Returned the enclosure; used USB-C to USB-C |
| Devices skipped Pi-hole after the move | IPv6 on the LAN gave devices the router as a DNS server | Turned off LAN IPv6 on the router |

## Habits that came out of this

- Back up host config files after every change.
- Change one thing at a time and test before moving on.
- Keep passwords in a password manager, not in my head.
