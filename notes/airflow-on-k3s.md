---
title: Airflow on k3s
---

## 설치

Proxmox VE 환경에서 CT를 이용하여 메인 서버를 구성할 것이다. 2코어, 1GB 램을
권장하므로[^1] 참고하여 컨테이너를 구성한다. 우분투 23.10로 구성하였다.

[^1]: https://docs.k3s.io/kr/installation/requirements#hardware

```bash
$ apt install curl
$ curl -sfL https://get.k3s.io | sh -
```
