# Storage and backups

## Disks

| Disk | Mounted at | Used for |
| --- | --- | --- |
| NVMe SSD (LVM thin pool) | `local-lvm` | Proxmox, container and VM disks |
| NVMe thin volume, 344 GB | `/mnt/fast` | Fast Samba share |
| 500 GB HDD (ext4) | `/mnt/pve/hdd` | Main Samba share, backups, fast share copies |

The HDD is mounted by UUID with `nofail`, so the server still boots if the drive is missing. See [`configs/proxmox/fstab.example`](../configs/proxmox/fstab.example).

## Samba shares

| Share | Path | Speed from the PC | Mapped as |
| --- | --- | --- | --- |
| `fast` | `/mnt/fast` | about 284 MB/s (2.5 Gb network) | Y: |
| `share` | `/mnt/pve/hdd/share` | about 110 MB/s (limited by the HDD) | Z: |

See [`configs/samba/smb.conf.example`](../configs/samba/smb.conf.example).

## Backups

| What | How | When | Kept |
| --- | --- | --- | --- |
| All containers and VMs | Proxmox backup job, ZSTD, snapshot mode, to the HDD | Sunday 01:00 | Last 4 |
| Fast share | `rsync -a` to `/mnt/pve/hdd/fast-backup` (keeps deleted files) | Daily 03:00 | Rolling |
| Host config files | Copies of network, Samba, firewall, storage and backup job files | After every change | Latest |

## Restore order (used for the NVMe migration)

1. Reinstall Proxmox, set the same IP and hostname.
2. Mount the HDD and re-add it as a storage.
3. Restore Pi-hole first, so DNS works.
4. Restore the remaining containers, then the VMs.
5. Restore host files: `/etc/network/interfaces`, `/etc/samba/smb.conf`, crontab.
6. Recreate the backup job and API tokens (tokens are not in container backups).

## Known gaps

- The main share lives only on one old HDD. Plan: a second drive (or the spare SATA SSD) for a nightly copy.
- No recycle bin on Samba yet. Plan: enable `vfs_recycle` on both shares.
