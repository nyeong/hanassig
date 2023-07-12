---
title: ProxmoxVE
---

- [[proxmox-archlinux]]
- [[proxmox-setup]]
- [[proxmox-storage]]

## VM이 안 꺼질 때

VM에 Shutdown 명령을 보냈는데 빙글빙글 돌기만 하고 반응을 하지 않을 때가 있다.
보통 게스트에 QEMU가 안 깔려있는데, VM 설정에서 QEMU Guest Agent가 켜져 있는
경우가 많다.

kvm 프로세스를 강제로 꺼주자:

```bash
$ ps aux | grep [VM ID]
$ kill -9 [PID]
```

[//do]: # "inner-links"

[proxmox-archlinux]: proxmox-archlinux.md
[proxmox-setup]: proxmox-setup.md
[proxmox-storage]: proxmox-storage.md

[//end]: # "2023-07-12 07:28"
