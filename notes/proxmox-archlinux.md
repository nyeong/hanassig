---
title: ProxmoxVE에 아치 리눅스 올리기
date: 2023-05-09
tags:
  - proxmox
  - archlinux
---

아치 리눅스는 다른 배포판에 비해 설치하는 게 여간 불편한 것이 아니다.
처음 설치할 때부터 입맛대로 할 수 있다는 점이 매력이지만, 매번 하나하나 다
설정해줘야하는 것이 여간 불편한 점이 아니다. 특히 실제 로컬이 아닌 ProxmoxVE에
게스트로 올리면 SSH를 설치하기 전까지 웹 셸에서 작업해야하므로 굉장히 불편하다.

공식에서 [cloud-init](https://cloud-init.io/)이 미리 설치된 이미지를 제공하는데
이를 이용하면 ProxmoxVE에서 SSH 공개키만 넘겨주면 SSH 설정을 마무리 할 수 있다.

[Arch Linux on a VPS](https://wiki.archlinux.org/title/Arch_Linux_on_a_VPS#Official_Arch_Linux_cloud_image)

Proxmox 노드 셸에서 아래와 같이 아치리눅스의 qcow2 이미지를 받아 템플릿에 넣는다.

```bash
$ curl -O https://geo.mirror.pkgbuild.com/images/latest/Arch-Linux-x86_64-cloudimg.qcow2
$ mkdir /var/lib/vz/template/qcow/
$ cp Arch-Linux-x86_64-cloudimg.qcow2 /var/lib/vz/template/qcow/
```

임의의 VM을 하나 생성한다. OS 단계에서 실치 이미지는 선택하지 않는다.
VM 생성 후 Proxmox 노드 셸에서 아래의 명령어로 VM에 qcow2 이미지를 이용하여
디스크를 추가한다.

```bash
$ qm importdisk [VM ID] [QCOW2 PATH] [DISK STORAGE]

# 예시
$ qm importdisk 103 Arch-Linux-x86_64-cloudimg.qcow2 local-lvm
```

완료하면 VM에 `Unused Disk 0`가 추가된다. 부팅 순서에서 이 디스크를 제일 앞으로
변경한다. CloudInit Drive를 추가한다. 추가하면 Cloud-Init 탭이 활성화되는데
해당 탭에서 유저이름, 비밀번호, SSH 공개키를 설정해줄 수 있다. 이때 dhcp도
켜주면 IP도 알아서 잘 받아온다.

```bash
# macOS에서는 아래처럼 공개키를 복사할 수 있다
$ cat [PUB KEY PATH] | pbcopy

$ cat ~/.local/id_ed25519.pub | pbcopy
```

바로 ip를 알면 바로 SSH로 접속할 수 있을텐데... qemu agent 없이 알아내는 것이
여간 번거로운 게 아니라 그냥 웹 콘솔로 들어가서 업데이트부터 해준다.

```bash
$ sudo pacman-key --init
$ sudo pacman-key --populate
$ sudo pacman -Syu
$ sudo pacman -S qemu-guest-agent
```

설치 후 VM을 꺼주고 Options에서 QEMU Guest Agent를 켜줘야 하는데, `shutdown`
명령으로 VM을 끄더라도 호스트에서는 인지를 못하니 그냥 쿨하게 Stop 해준다.

끈 김에 ProxmoxVE 노드 셸에서 디스크 크기도 조정해준다.

```bash
$ qm resize [VMID] [DISK NAME] [SIZE]

# 예시
$ qm resize 103 virtio0 +64G
```

QEMU Guest Agent Enabled해주고 다시 켜면 Summary에서도 IP를 확인할 수 있다.

```bash
$ ssh [USERNAME]@[VM IP]
$ neofetch
                   -`                    nyeong@portainer
                  .o+`                   ----------------
                 `ooo/                   OS: Arch Linux x86_64
                `+oooo:                  Host: KVM/QEMU (Standard PC (i440FX + PIIX, 1996) pc-i440fx-7.2)
               `+oooooo:                 Kernel: 6.3.1-arch1-1
               -+oooooo+:                Uptime: 43 mins
             `/:-:++oooo+:               Packages: 161 (pacman)
            `/++++/+++++++:              Shell: bash 5.1.16
           `/++++++++++++++:             Resolution: 1280x800
          `/+++ooooooooooooo/`           Terminal: /dev/pts/0
         ./ooosssso++osssssso+`          CPU: Common KVM (2) @ 2.496GHz
        .oossssso-````/ossssss+`         GPU: 00:02.0 Vendor 1234 Device 1111
       -osssssso.      :ssssssso.        Memory: 119MiB / 3920MiB
      :osssssss/        osssso+++.
     /ossssssss/        +ssssooo/-
   `/ossssso+/:-        -:/+osssso+-
  `+sso+:-`                 `.-/+oso:
 `++:.                           `-/+/
 .`                                 `/

$ free -h
               total        used        free      shared  buff/cache   available
Mem:           3.8Gi       107Mi       3.5Gi       0.0Ki       179Mi       3.5Gi
Swap:          511Mi          0B       511Mi
```

간편하게 아치 리눅스 설치 끝~
