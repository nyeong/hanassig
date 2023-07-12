---
title: Zellij
date: 2023-05-09
tags:
  - 개발환경
---

[zellij-org/zellij](https://github.com/zellij-org/zellij)

터미널 작업공간 관리자.

## 단축키

문서가 있긴 한데 [설정 파일](https://github.com/zellij-org/zellij/blob/main/example/config.kdl)을
보는 편이 빠르고 편하다.

### pane

- `c-p w`: floating pane 만들기
- `c-p e`: floating pane <-> embeded pane 전환
- `c-p f`: pane 전체화면. tmux의 zoom.
- `c-p c`: pane 이름 바꾸기.
- `a-+`, `a--`: pane 크기 조절
- `c-h h,j,k,l`: pane 이동

### 검색

- `c-s s`: 검색 모드. 이 상태로 입력하면 된다.
- `c-s e`: 현재 보고 있는 화면 내용을 에디터로 옮긴다.
- `enter`: 검색
  - `c`: 대소문자 구분 토글
