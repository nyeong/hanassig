---
title: 💻 개발환경
description: 내 개발환경 정리
---

- 셸: [[zsh]].
- 편집기: [helix](#helix), [[vs-code]]
- 터미널 파인더: nnn
- 터미널 멀티플렉서: tmux, [zellij](https://zellij.dev/) 써보는 중
- dotfile 관리: [nyeong/.dotfiles](https://github.com/nyeong/.dotfiles)
- 생각 정리: obsidian, helix
- 언어 버전 관리: [[asdf]]

## 시스템

- MacBook Air (M1, 2020) -- [[macos]] 참고
- [[uibox]]

## 텍스트 편집기

helix를 주로 쓰고 있다. 이제 vim 커맨드는 불안해서 잘 못 쓰겠다.

뭘 쓰는 아래 기능은 있어야 좋겠다:

- fuzzy finder
- modal editing
- tree-sitter support
- LSP support
- multi cursor

### helix

> A post-modern text editor.

https://helix-editor.com/

터미널에서 돌아가는 선택 기반 모달 에디터이다.

- modeless-editor인 VS Code 등과 비교하면:
  - 마우스나 방향키에 손이 갈 필요 없다.
  - 터미널을 나갈 필요가 없어서 터미널 멀티플렉서와 같은 기존의 도구들을
    자연스레 쓸 수 있다.
  - SSH로 서버에 접속해서 쓸 때에도 편리하다.
- 같은 modal-editor인 vim과 비교하면:
  - vim은 명령 →  선택 순서로 명령어를 입력하여, 명령이 영향을 끼치는 범위가
    눈에 보이지 않는다.
  - helix는 선택 →  명령 순서이기 때문에 선택된 영역이 눈으로 보여 익히기 쉽다.
- 같은 선택 기반 modal-editor인 kakoune과 비교하면:
  - 다중선택, LSP, tree-sitter, fuzzy finder 등 편리한 기능이 내장되어있다.
  - 자체적인 윈도우 매니저가 있다.
  - 단일 클라이언트 구조이고, 플러그인 기능이 없어서 기존 도구들과의 병합이
    조금 어려운 편이다.

helix가 다 괜찮은데 몇가지 불만이 있다.

묘한 곳에서 관심사의 분리가 철저하다. 텍스트 편집기이니 저장할 때
[[final-newline]]은 알아서 고쳐주면 좋을텐데, 이런 옵션이 없다. 이슈를 살펴보니
그러한 내용을 바꾸는 기능은 LSP등이 담당해야할 영역이기 때문에 에디터에 넣을
계획이 없다고 한다. (이슈 번호는 까먹었다)

플러그인이나 훅 시스템이 없다. 위의 문제도 훅이 있다면 저장할 때마다 마지막
줄이 정상적인지 직접 확인할 수 있을텐데.
간단하게 마크다운 파일을 저장할 때마다 수정한 날짜를 업데이트 하고 싶어도
어렵다.

자체적인 윈도우 시스템을 사용한다. 빠르고 별다른 설정이 필요 없는 것은 좋지만
기존의 시스템과 결합하기가 어렵다. 나는 터미널 멀티플렉서로 zellij를 쓰고 있다.
zellij의 여러 편리한 창 관리 시스템을 helix에서 쓸 수 없어서 아쉽다.

helix가 나오기 전에는 kakoune을 썼다. kakoune에서 helix로 넘어간 결정적인 이유는
[키맵 토론](https://github.com/helix-editor/helix/issues/165)이 활발하게
이루어지고 있고, 상당 부분 합리적이라고 공감하여 내가 귀찮게 키맵 설정을 하지
않아도 되리라 생각했기 때문이다. 거기에 완성도 높은 tree-sitter, lsp 지원이
내장되어 정말 별 설정 안해도 편리하게 쓸 수 있다는 점이 좋았다.

## 터미널 멀티플렉서

zellij 써보는 중.

## 참고

- [제 2회 EXCELCON - Neovim으로 생산성 퀀텀점프하기](https://kodingwarrior.github.io/wiki/appendix/excelcon-2nd/)

[//do]: # "inner-links"

[asdf]: asdf.md
[macos]: macos.md
[uibox]: uibox.md
[vs-code]: vs-code.md
[zsh]: zsh.md

[//end]: # "2023-07-12 07:28"
