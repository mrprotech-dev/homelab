# Network

## Addressing plan

The router hands out addresses from the top half of the subnet, so the bottom half is free for fixed addresses.

| Range | Used for |
| --- | --- |
| Gateway | ISP router |
| Fixed, below the DHCP pool | Proxmox host, then one address per container (Pi-hole, Open WebUI, Homepage, Grafana, Jarvis, SearXNG) |
| DHCP reservation | Gaming PC, reserved by MAC address so Open WebUI and Wake-on-LAN always find it |
| Fixed, below the DHCP pool | Sandbox VM and vault VM |
| DHCP pool | Phones, laptops and everything else |

Keeping servers outside the DHCP pool means the router can never hand one of their addresses to another device.

## Physical layout

```
ISP line ── router ── wall socket ═══ cable in the wall (1 Gb) ═══ wall socket ── 2.5 Gb switch
                                                                                   ├── Proxmox server (2.5 Gb)
                                                                                   └── Gaming PC (2.5 Gb)
```

The server and PC sit on the same switch, so file copies between them run at 2.5 Gb even though the wall cable is 1 Gb. Before relying on the wall cabling, I tested which sockets were linked by plugging a powered device into each end and watching the port lights, then checked the link speed.

## Router settings

- **DHCP pool:** top half of the subnet only.
- **DNS:** set to Static, with Pi-hole as the only DNS server. No second server, so devices cannot skip Pi-hole.
- **LAN IPv6:** off. With IPv6 on, devices also received the router as an IPv6 DNS server and skipped Pi-hole.
- **Static DHCP:** a reservation for the gaming PC.

## DNS

- Every device asks Pi-hole. Pi-hole forwards anything it does not block to a public resolver.
- With my previous router, DNS was forwarded through the router, so Pi-hole saw every device as one client and its rate limit could cut everyone off. With the router now handing out Pi-hole directly, each device shows up separately.
- The Proxmox host uses a public resolver directly, so it can still update and resolve names if Pi-hole is down.

## Wi-Fi

- Scanned nearby networks with `netsh wlan show networks mode=bssid`.
- 5 GHz had a channel to itself; the default 2.4 GHz channel was shared with three neighbours, so 2.4 GHz moved to a quieter channel.
- Moving the router out of a cupboard and away from large metal appliances was the biggest improvement.

## Firewall

- Proxmox datacenter firewall on; host firewall off.
- Sandbox VM: allow out to the internet and to the router for DNS; drop everything else on the home subnet.
- Vault VM: same isolation, reached only through the Proxmox SPICE console.
