---
title: asdf
date: 2023-04-28
tags:
  - 개발환경
---

[asdf](https://asdf-vm.com/)

다양한 언어를 하나의 명령어로 버전관리 할 수 있어서 편하다.
왠만한 언어들은 OS의 패키지 매니저가 아니라 asdf-vm으로 관리하는 중.

## 장점

다양한 프로그래밍 언어 버전을 하나의 프로그램으로 관리할 수 있다.

- 명령어가 통일되어 편하다.
- `$PATH`가 깔끔해져서 편하다. `rbenv`, `pyenv`와 같은 프로그램을 각각 쓰면
  `$PATH`에 shims이 가득 차더라.

```bash
$ asdf list
elixir
 *1.14.4
erlang
 *25.3
nodejs
  18.16.0
 *lts
python
 *3.10.11
ruby
 *3.2.2
```

### 용례

```bash
# gleam이라는 언어를 설치해보자:
# gleam 플러그인 설치
$ asdf plugin-add gleam https://github.com/asdf-community/asdf-gleam.git

# 설치 가능한 gleam 버전 보기
$ asdf list all gleam

# gleam 최신 버전 설치
$ asdf install gleam latest

# 설치된 gleam 버전 보기
$ asdf list gleam

# 시스템의 기본 버전을 최신 버전으로 설정하기
$ asdf global gleam latest

# 이 디렉토리에서는 특정 버전의 gleam 쓰기
$ asdf local gleam 0.26.1
```

### 설치

[asdf의 가이드](https://asdf-vm.com/guide/getting-started.html#_1-install-dependencies)에서는
brew나 pacman 같은 패키지 매니저를 이용한 설치도 소개하고 있는데, git으로
설치하는 편이 가장 관리하기 편한 것 같다. 패키지 매니저를 이용할 경우
다양한 환경을 쓸 때, 환경마다 설치 위치가 달라져 관리가 불편하다.

가이드에서 권장하는 설치 위치는 `~/.asdf`인데, 
`~/.local/share/asdf`에 설치하면 홈 디렉토리를 깔끔하게 유지할 수 있다.
설치 위치를 바꾸었으면 [환경변수도 바꾸어주자](https://asdf-vm.com/manage/configuration.html#environment-variables).

```bash
$ mkdir -p ~/.local/share
$ git clone https://github.com/asdf-vm/asdf.git ~/.local/share/asdf --branch v0.11.2
```

설치 위치를 바꾸었으면 관련 변수도 바꾸어주어야한다. `.zshrc`와 같은 셸 설정파일에
아래와 같이 `ASDF_DIR`을 설정한다.

```bash
# asdf-vm
if [[ -d ~/.local/share/asdf ]]; then
  export ASDF_DIR=$HOME/.local/share/asdf
  export ASDF_DATA_DIR=$HOME/.local/share/asdf

  . $ASDF_DIR/asdf.sh
fi
```