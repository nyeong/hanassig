---
title: 💻 개발환경
description: 내 개발환경 정리
---

- 셸: [zsh](zsh)
- 편집기: [helix](#helix), [vs-code]
- 터미널 파인더: nnn
- 터미널 레이아웃: tmux, [zellij](https://zellij.dev/) 써보는 중
- dotfile 관리: [nyeong/.dotfiles](https://github.com/nyeong/.dotfiles)
- 생각 정리: obsidian, helix
- 언어 버전 관리: asdf-vm

## 시스템

- MacBook Air (M1, 2020) -- [[macos]] 참고

## helix

> A post-modern text editor.

https://helix-editor.com/

터미널에서 돌아가는 선택 기반 모달 에디터이다.

- 모달 에디터라 vim이나 emacs처럼 모드를 바꿔가며 쓴다.
  - 마우스나 방향키가 필요 없어 손이 키보드를 떠날 필요가 적다.
  - 다양한 명령어를 간편한 단축키로 쓸 수 있다.
- 선택 기반 모달 에디터이다.
  - vim은 명령 → 선택 순서로 명령어를 입력하여, 명령이 영향을 끼치는 범위가 눈에 보이지 않는다.
  - helix는 선택 → 명령 순서로 입력하여 선택된 영역이 눈으로 보여 익히기 쉽다.
- 터미널에서 TUI로 돌아간다.
  - SSH에서도 쓸 수 있다.
  - 메모리도 적게 먹는다.
- 여러 기능이 내장되어 있다.
  - 다중선택, LSP, tree-sitter, fuzzy finder 등등

아직 플러그인을 지원하지 않는 것이 큰 단점이다.

## asdf-vm

[asdf](https://asdf-vm.com/)

다양한 언어를 하나의 명령어로 버전관리 할 수 있어서 편하다.
왠만한 언어들은 OS의 패키지 매니저가 아니라 asdf-vm으로 관리하는 중.

### 용례

```bash
# gleam 플러그인 설치
asdf plugin-add gleam https://github.com/asdf-community/asdf-gleam.git

# 설치 가능한 gleam 버전 보기
asdf list all gleam

# gleam 최신 버전 설치
asdf install gleam latest

# 설치된 gleam 버전 보기
asdf list gleam

# gleam 최신 버전을 기본으로 쓰기
asdf global gleam latest

# 이 디렉토리에서는 특정 버전의 gleam 쓰기
asdf local gleam 0.26.1
```

### 설치

git으로 설치한다. 기본 설치 위치는 `~/.asdf`이다.
`~/.local/share/asdf`에 설치하면 유저 레벨에서 깔끔하게 관리할 수 있다.
설치 위치를 바꾸었으면 [환경변수도 바꾸어주자](https://asdf-vm.com/manage/configuration.html#environment-variables).

```bash
mkdir -p ~/.local/share
git clone https://github.com/asdf-vm/asdf.git ~/.local/share/asdf --branch v0.11.2
```

homebrew나 pacman 등 패키지 매니저에서 지원하긴 하는데, 환경마다 설치 위치가 달라져 관리하기 힘들고, 공식 문서에서도 권장하지 않는다.[^1]

[^1]: https://asdf-vm.com/guide/getting-started.html#community-supported-download-methods

설치 후 셸에서 불러와야 한다. 셸에서 PATH 설정을 완료한 후 `asdf.sh` 파일을 불러와야한다.

공식 문서에서 하라는 대로 셸 설정 파일(`.bashrc`, `.zshrc` 등)의 마지막에 아래 한 줄만 추가하면 쓸 수 있다.

```bash
. $HOME/.asdf/asdf.sh
```

나는 설정을 별도로 분리하고 싶어서 `.dotfiles/zsh/init.zsh`에 아래처럼 추가하고 이 파일을 `~/.zshrc`에서 부르고 있다.

```zsh
# asdf-vm
if [[ -d ~/.local/share/asdf ]]; then
  export ASDF_DIR=$HOME/.local/share/asdf
  export ASDF_DATA_DIR=$HOME/.local/share/asdf
  
  . $ASDF_DIR/asdf.sh
fi
```

## zellij

zellij 써보는 중.