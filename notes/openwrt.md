---
title: OpenWrt
description: OpenWrt로 라우터 써먹기
date: 2023-03-02
tags:
---

## Wireguard를 이용한 VPN 설정

VPN은 공개 네트워크에서 비밀 네트워크로 접속할 때 유용한 보안 기술이다. 이를 이용하면 외부에서도 홈 네트워크에 안전하고 편리하게 접속할 수 있다.

다양한 프로토콜이 있는데, 최근 리눅스 커널(5.6)에 포함된 wireguard가 편리하다.

OpenWRT를 VPN 서버로 이용할 수 있다.

[WireGuard basics](https://openwrt.org/docs/guide-user/services/vpn/wireguard/basics)

### 설치

wireguard 프로토콜 자체는 커널에 포함되었으나, 관리도구는 별도로 설치해야한다. LuCI에서 편히 쓰고자 설치하는 거라서 없어도 무방하긴 하다. SSH로 접속하여 다음을 진행한다:

```
opkg update
opkg install luci-proto-wireguard luci-app-wireguard
/etc/init.d/network restart
```

혹은 LuCI → System → Software에 접속하여 두 패키지를 찾아 설치한다. 그 후 LuCI → System → Startup → Initscripts → network에서 restart를 누른다.

### 키쌍 생성하기

wireguard는 공개키 암호화 방식을 이용한다. 다음 명령어로 공개키 쌍을 생성하자:

```
mkdir /etc/wireguard
cd /etc/wireguard
wg genkey | tee uibook | wg pubkey > uibook.pub
chmod 600 uibook
```

`/etc/wireguard`는 키 저장을 위하여 임의로 만든 공간이다. `wg genkey` 명령어로 비밀키를, `wg pubkey` 명령어로 공개키를 만든다. 그중 비밀키는 반드시 권한을 `600`으로 수정하자.

### 인터페이스 생성하기

새로운 프로토콜(wireguard)를 사용하기 때문에, 통신을 위해서 새로운 인터페이스를 정의해야한다. LuCI → Network → Interfaces에서 할 수 있다.

- 이름: wg0. 그냥 이걸 제일 많이 쓰더라.
- protocol: WireGuard VPN
- private key: 아까 생성한 비밀키
- public key: 아까 생성한 공개키
- listen port: 49152 ~ 65535에서 고르면 된다는데 그냥 두면 랜덤 되는 듯
- ip addresses: 해당 인터페이스에 할당할 IP이다. 10.9.0.1/24로 했다. 이 IP가 게이트웨이 역할을 한다.

`/etc/config/network` 파일을 편집하여서 할 수도 있다. 아래처럼 추가하면 된다.

```
config interface 'wg0'
        option proto 'wireguard'
        option private_key '[비밀키 내용 입력]'
        list addresses '10.9.0.1/24'
```

### 피어 설정하기

같은 곳에서 피어 설정도 같이 진행해야 한다. 피어란 접속하고자 하는 기기이다. 아래의 앱을 이용하면 편리하게 접속할 수 있다.

[Installation - WireGuard](https://www.wireguard.com/install/)

접속자도 공개키/비밀키 쌍을 만들고 공개키를 wireguard 서버에 등록해야한다. 그러나 서버에서 공개키/비밀키를 생성하고 이 자체를 공유해버릴 수도 있다.

따라서 LuCI에서 `Generate new key pair`로 키쌍을 만들어버리고, 설정을 완료한 후 해당 설정을 QR 코드나 conf 파일 형태로 접속을 원하는 피어에 공유하여 등록하면 편하게 피어를 설정할 수 있다. QR코드로 보기 위해서는 qrencode 패키지를 설치해야한다.

- Public Key: 접속하고자 하는 장치의 공개키
- Private Key: 접속하고자 하는 장치의 비밀키. 접속에는 필요 없지만 이를 넣으면 설정파일 공유할 때 편해진다.
- Preshared Key: 사실 뭔지 모르겠다.
- Allowed IPs: 피어가 터널 안에서 쓰도록 허용한 IP 대역.
- Persistent Keep Alive: 25가 권장값인듯

```
config wireguard_wg0
        option public_key 'cIDLafiUna6OyxWd4aCtmTpGt1XIaCGVzmfEuEC4nmQ='
        option private_key '[검열 삭제]'
        option preshared_key '[검열 삭제]'
        list allowed_ips '10.9.0.0/24'
        option persistent_keepalive '25'
```

설정 후 가장 밑의 `Generate configuration...`을 누르면 설정을 피어에게 내보낼 수 있다. 이를 복사하거나 QR코드로 촬영하여 등록한다.

```
[Interface]
PrivateKey = 이 클라이언트의 개인키
Address = 할당 받을 IP (예: 10.9.0.3/24)
DNS = 라우터 DNS (192.168.1.1)

[Peer]
PublicKey = 서버의 공개키
AllowedIPs = 0.0.0.0/0
Endpoint = 서버주소:포트
```

여기서 `AllowedIPs`는 VPN을 거칠 IP를 의미한다. `0.0.0.0/0`으로 되어있다면
모든 접속을 VPN을 거쳐서 하게 된다.

### 방화벽 설정

이제 방화벽을 개방해주어야한다. LuCI → Network → Firewall에서 설정 할 수 있다. 이 작업은 `/etc/config/firewall`을 수정하여서 할 수도 있다.

General Settings 하단의 Zones에서 Add를 눌러 존을 만든다.

- Name: 원하는 이름으로 한다. 여기서는 `wireguard`로 하였다.
- Input/Output: Accept
- Forward: Reject
- Masquerading: 체크하라는데 뭔지는 모르겠다.
- MSS clamping: 체크하라는데 뭔지는 모르겠다.
- Covered Networks: 아까 만든 `wg0`
- Allow forward to destination zones: 이 존에서 어떤 존으로 갈 수 있는 지를 묻는 것이다. VPN으로 접속시 내부 네트워크와 외부망을 모두 쓰고 싶으므로 `lan`, `wan`을 고른다
- Allow forward to source zones: 외부망에서는 접근을 원치 않으므로 `lan`만 고른다.

```
config zone
        option name 'wireguard'
        option input 'ACCEPT'
        option output 'ACCEPT'
        option forward 'REJECT'
        option masq '1'
        option mtu_fix '1'
        list network 'wg0'

config forwarding
        option src 'wireguard'
        option dest 'lan'

config forwarding
        option src 'wireguard'
        option dest 'wan'

config forwarding
        option src 'lan'
        option dest 'wireguard'
```

이제 포트를 개방해줄 차례이다.

Traffic Rules 탭에 들어가 Add를 누른다.

- Name: 작명 규칙에 맞게 `Allow-Wireguard`로 하자.
- Protocol: wireguard는 UDP를 사용하므로 UDP만 체크한다
- Source zone: 외부에서의 접속이므로 `wan`에 체크한다.
- Destination port: 기본 wireguard 포트인 51820을 쓴다.
- Action: 당연히 accept
