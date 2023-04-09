---
title: Proxmox 저장장치 설정
description: Proxmox VE에 저장장치를 설정하기
date: 2023-03-18
tags:
---

## 현재 상황

현재 시스템에 연결된 저장장치는 세 개이다:

1. NVME SSD (256GB)
2. HDD (14TB)
3. HDD (2TB)

- 호스트 OS : Proxmox VE를 돌릴 공간
- NAS, cloud : 클라우드 저장소 서비스를 대체하기 위함
  - SMB, nextcloud, 
- DB
- 그 외 VM을 돌릴 가상 드라이브

## 의문

1. Proxmox VE에서 직접 스토리지 다루기 vs Guest NAS OS에 패스스루하기.
2. NextCloud + SMB를 쓰려면 TrueNAS같은 운영체제를 설치하는 것이 좋은가?
아니면 그냥 리눅스에 깔아도 무방한가?
3. NextCloud를 쓰면 SMB, AFP, NFS 같은 서비스들이 굳이 필요할까?

## NAS 운영하기

- 어디서든 데이터 접근
- 사진 백업

SMB, AFP, NFS

- TrueNAS
- OMV
- Linux
- Synology

서비스는

- nextcloud
- photoprism
- filerun

따라서 아래와 같이 계획을 잡음

1. 디스크 관리: Proxmox VE에서 ZFS로.
2. 공유 서비스: NextCloud를 최대한 활용.

## 스토리지 설정

ZFS로 구성하려면 RAID, 압축 여부, ashift 등을 설정해야함.

- RAID: 갖고 있는 디스크가 14TB, 2TB로 용량 차이가 크므로 RAID를 하지 않았음
- 압축: 일반적으로 lz4가 자원 대비 성능이 좋아 공식 문서에서도 이를 추천함
- ashift: 블록의 크기를 결정함. HDD의 블록의 크기가 4KB이므로 12를 썼음.