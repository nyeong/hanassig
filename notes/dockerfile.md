---
title: Dockerfile
date: 2023-05-10
---

## 기본적인 명령어

- FROM: 기초 이미지
- COPY: 도커 이미지에 파일을 추가하기
- RUN: 도커 이미지 생성을 위해 실행하는 명령
- CMD: 컨테이너가 실행될 때 실행하는 명령
- EXPOSE: 노출할 포트
- ENV: 환경변수 지정

## 빌드하기

```bash
$ docker build -t [IMAGE NAME] [PATH]
```

## 참고

- [Containerize an application](https://docs.docker.com/get-started/02_our_app/)
