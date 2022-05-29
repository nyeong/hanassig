# WireGuard 설치하기

[UiRouter](notes/DIY/uirouter)에 [WireGuard](https://www.wireguard.com/)로
VPN을 설치하여 외부에서 내부망으로 접근할 수 있도록 하자.

## VPN

모두가 함께 접근할 수 있는 네트워크를 인터넷이라고 한다. 반대로 내가 만들고 나만 접근할 수 있는 망을
사설망이라고 부른다. 예를 들어, 집에서 공유기를 이용해 컴퓨터와 프린트를 연결한 네트워크 망은 사설망이다.

사설망은 보안 등의 이유로 외부에서 접근할 수 없도록 구성한다. 위에 예를 든 사설망이 외부에 공개된다면
인가되지 않은 외부 사용자가 프린트를 사용할 수도 있다.

그러나 종종 외부 인터넷에서 사설망에 접속할 필요가 있는데, 이때 필요한 것이 VPN이다.
VPN을 사용하면 인터넷 망에서 사설망에 접속하여 마치 내 컴퓨터가 사설망에 있는 것처럼 쓸 수 있다.

## 구성

![uibox 구성 개념도](notes/DIY/uirouter/uibox-diagram.jpg)

그림의 빨간색 내부망은 외부에서 접근할 수 없도록 분리되어있다. VPN은 여기서 일종의 터널같은 역할을 한다.
이 "터널"을 통한다면 외부에서도 내부망에 접근할 수 있다.

VPN을 구현하는 프로토콜에도 종류가 다양하다. OpenVPN, PPTP, L2TP/IPSec, IKEv2 등등 다양하다.

UiRouter에는 구성이 단순하고 속도가 빠른 WireGuard를 설치하였다.
WireGuard는 리눅스 커널에 공식으로 포함되기도 하였다.[^1][^2]

[^1]: https://lore.kernel.org/lkml/CAHk-=wi9ZT7Stg-uSpX0UWQzam6OP9Jzz6Xu1CkYu1cicpD5OA@mail.gmail.com/
[^2]: https://github.com/torvalds/linux/commit/bd2463ac7d7ec51d432f23bf0e893fb371a908cd

- UiRouter: WireGuard 서버
- 맥북, 아이패드, 휴대폰: WireGuard 클라이언트

## 설치

### wireguard 설치

```
# opkg update && opkg install wireguard-tools
# mkdir /etc/wireguard && cd &_
```

### 비밀키, 공개키 생성

```
# wg genkey | tee server.key | wg pubkey > server.pub
# chmod 700 *.key
```

비밀키, 공개키 쌍을 생성한다. 이 때 반드시 비밀키의 권한을 `700`으로 설정하여 권한 없는 사용자가 볼 수 없도록
해주어야 한다.

### 방화벽 설정

```
# /etc/config/firewall
config rule
        option name 'Allow-wireguard'
        option src 'wan'          # <- WAN, 즉 외부에서 오는 접근에 대한 설정
        option proto 'udp'        # <- UDP 프로토콜을 사용한다
        option dest_port '31194'  # <- 개방할 포트
        option target 'ACCEPT'    # <- 접근을 허용하겠다
# 설정 후 /etc/init.d/firewall restart
```

### 네트워크 설정

VPN 인터페이스와 VPN Peer(접속자)를 설정한다.

```
# /etc/config/network
config interface 'wg0'
        option proto 'wireguard'
        option private_key '[/etc/wireguard/server.key의 값을 입력한다]'
        option listen_port '31194'    # <- 사용할 포트
        list addresses '10.9.0.1/24'  # <- VPN peer에게 부여할 IP 대역

config wireguard_wg0
        option description 'devmachine'
        option public_key '[접속할 peer의 공개키를 입력한다]'
        option persistent_keepalive '25'
        list allowed_ips '10.9.0.2/32' # <- VPN peer가 할당받을 IP
# 설정 후 /etc/init.d/network restart
```

### 클라이언트 설정

[WireGuard -- Installation](https://www.wireguard.com/install/)

VPN 서버로 접속할 클라이언트에 클라이언트 프로그램을 다운받는다.

![wireguard macos preference](notes/DIY/uirouter/wireguard-macos-preference.png)

새로운 설정을 만들어준다. (클라이언트 프로그램에서는 **터널**이라고 부른다)

```
[Interface]
PrivateKey = [해당 클라이언트의 private key로 아마 자동으로 생성된다]
Address = 10.9.0.2/32 # <- 해당 클라이언트가 할당받을 IP
DNS = 192.168.1.1     # <- DNS 주소

[Peer]
PublicKey = [VPN 서버의 public key]
AllowedIPs = 0.0.0.0/0 # <- 로컬을 포함한 모든 접속을 VPN을 거치도록 설정
Endpoint = [VPN의 주소와 포트]
```


## 참고

- [VPN이란 무엇인가요?](https://aws.amazon.com/ko/what-is/vpn/)
- [OpenWrt wireguard 설치 및 설정](https://qquack.org/openwrt/wireguard/)
- [WireGuard](https://openwrt.org/docs/guide-user/services/vpn/wireguard/start)