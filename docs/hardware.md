# Hardware

## Server

| Part | Detail |
| --- | --- |
| Machine | Dell OptiPlex 5060 SFF, bought refurbished on eBay for £136 |
| CPU | Intel Core i5-8500 (6 cores, 6 threads) |
| RAM | 32 GB DDR4 (4 x 8 GB, running at 2400 MT/s) |
| Boot and VM disk | NVMe SSD (migrated from the original 256 GB M.2 SATA SSD) |
| Bulk storage | 500 GB Seagate Barracuda 3.5" HDD |
| Network | Realtek RTL8125 2.5 GbE PCIe card (`enp2s0`); onboard Intel I219-V (`nic0`) no longer used |

### Upgrades so far

1. **RAM, 16 GB to 32 GB.** Added a second pair of 8 GB DDR4 UDIMMs. Checked with `free -h` and `dmidecode`, then tested with memtest86+.
2. **Boot drive, SATA to NVMe.** Backed up every container and VM, reinstalled Proxmox on the NVMe, restored the backups in a planned order, then restored host config files (network, Samba, storage, firewall).
3. **Network, 1 Gb to 2.5 Gb.** Added a YuanLey RTL8125B card and a BrosTrend 5-port 2.5 Gb switch. Moved the Proxmox bridge to the new card. PC to server copies went from about 110 MB/s to 284 MB/s.

### Limits worth knowing

- The SFF case has one 3.5" bay and no spare SATA power, so more hard drives would go in a USB enclosure.
- The 500 GB HDD is from 2011. It is checked monthly with `smartctl` and is the next thing to replace.

## Gaming PC (used for local AI)

| Part | Detail |
| --- | --- |
| CPU | AMD Ryzen 7 7800X3D |
| GPU | NVIDIA RTX 5070 (12 GB VRAM) |
| Motherboard | ASUS PRIME B850M-A WIFI (onboard Realtek 2.5 GbE) |
| Role | Runs Ollama for Open WebUI; woken with Wake-on-LAN when needed |

## Network kit

| Device | Detail |
| --- | --- |
| Router | ISP-supplied router |
| Switch | BrosTrend 5-port 2.5 Gb unmanaged switch |
| Cabling | Cat5e in the wall (tested at 1 Gb), Cat6 patch leads |
