 Proxmox 설정

## 요구사항

[Proxmox -- System Requirements](https://www.proxmox.com/en/proxmox-ve/requirements)

- 가상화 가능한 인텔/AMD CPU (Intel VT/AMD-V)
- 메모리
  - 호스트 OS (Proxmox VE)를 위해 최소 2GB 메모리
  - 게스트 OS를 위해 필요한 만큼의 메모리
  - ZFS를 위해 1TB 당 1GB의 메모리

## 그 외 선택지

- ESXi
- TrueNAS SCALE

## 저장소 목록 수정하기

![](uibox-repositories-enterprise)

1. 좌측 서버 뷰에서 생성한 노드를 고르고, 업데이트 → 저장소에 들어간다.
2. 하단의 `pve-enterprise`를 선택하고 `Disable`한다.
3. `Add`를 누르고 repository로 `No-Subscription`을 선택한다.
4. `Updates` 탭으로 돌아가서 `Refresh`, `Upgrade` 한다.

상기한 내용은 CLI로도 가능하다.

```bash
# no-subscription 저장소 추가하기
$ cat >> /etc/apt/sources.list
deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription
^D

# subscription 저장소 삭제하기
$ sed -i 's/^d/# d/g' /etc/apt/sources.list.d/pve-enterprise.list

# 업데이트 및 업그레이드
$ apt update && apt upgrade
```

## 다크모드

[Weilbyte](https://github.com/Weilbyte/PVEDiscordDark)

다크모드로 바꿔준다.

## 사용자 만들기

```bash
$ apt install sudo
$ adduser -m nyeong -G sudo -s /usr/bin/bash
$ passwd nyeong
$ visudo
```
