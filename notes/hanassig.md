---
title: 하나씩
description: 공부한 거 정리하기
tags:
  - diy
---

## 목표

- 배운 것들을 조리있게 정리하기
  - 정보를 정리하는 과정에서 더 잘 기억하고 구조화하기
  - 나중에 기억나지 않더라도 찾아볼 수 있도록 하기
- 로컬에서 편리하고 빠르게 정리하기
- 웹으로 퍼블리싱하기
  - 댓글 기능이 필요해져서 웹으로 퍼블리싱이 필요하다.
  - [giscus](https://giscus.app/ko)를 이용하자.

## 구성

- [nyeong/hanassig](https://github.com/nyeong/hanassig) — 해당 저장소

## 디렉토리 구성

- `assets/` — 이미지, 동영상 등 첨부파일
- `notes/` — 문서를 모아둔 곳
  - 문서는 서브 디렉토리 없이 구성하자.
  - 문서의 제목은 `slug`로 사용하자. slug는 `/^[a-z0-9]\-\.md$/`.

## 글 구성

```md
---
title: 글 제목
description: 글 설명
date: 글 작성 일자
tags:
  - 태그
---
```

- 내부 문서 링크는 위키 문법을 이용하자. `\[\[wiki-style\]\]`

## 도구

- obsidian
- foam
- helix

## 참고

- [기계인간 John Grib](https://johngrib.github.io/)
- [MaggieAppleton/digital-gardeners](https://github.com/MaggieAppleton/digital-gardeners)
- [TuanManhCao/digital-garden](https://github.com/TuanManhCao/digital-garden)
- [테크니컬 라이팅 깔끔하게 완성하는 10가지 원칙](https://insight.infograb.net/blog/2023/03/30/technical-writing-guide/)
- [Why engineers should focus on writing](https://www.yieldcode.blog/post/why-engineers-should-write/)
  - [엔지니어가 글쓰기에 집중해야 하는 이유](https://news.hada.io/topic?id=9963)
- [Stopping at 90%](https://austinhenley.com/blog/90percent.html)
- [What makes developers productive?](https://jeremymikkola.com/posts/developer_productivity.html)
  - [무엇이 개발자를 생산적이게 만드는가](https://news.hada.io/topic?id=10222)
