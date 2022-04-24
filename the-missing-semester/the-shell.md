# The Shell

[https://missing.csail.mit.edu/2020/course-shell/]

## 숙제

### 시스템 셸 확인하기

```
$ echo $SHELL
/bin/zsh
```

셸은 `chsh -s <셸 파일 경로> <사용자 이름>` 명령어로 바꿀 수 있다.
`chsh` 명령어로 셸을 바꾸기 위해서는 `/etc/shells` 파일에 바꾸고자 하는 셸이 등록되어 있어야 한다.

```
# /etc/shells
/bin/bash
/bin/csh
/bin/dash
/bin/ksh
/bin/sh
/bin/tcsh
/bin/zsh
```

다른 사용자의 셸이 알고 싶다면 `/etc/passwd` 파일을 참고하면 된다.

```
# /etc/passwd
root:*:0:0:System Administrator:/var/root:/bin/sh
```

macOS의 경우 조금 달라서 아래와 같은 방법으로 확인해야한다.

```
# 유저 목록 확인
$ dscl . list /Users

# 유저 쉘 정보 확인
$ dscl . -read /Users/<유저 이름> | grep Shell
```

`$SHELL` 말고도 다른 환경변수 내용을 알고 싶다면 `env` 명령어를 쓰면 된다.

```
$ env
COLORTERM=truecolor
HOME=/Users/nyeong
LANG=ko_KR.UTF-8
LOGNAME=nyeong
PATH=/Users/nyeong/.asdf/shims:/Users/nyeong/.asdf/bin:/Users/nyeong/.zinit/polaris/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:/opt/homebrew/sbin:/Users/nyeong/.cargo/bin:/Users/nyeong/.cargo/bin/:/opt/homebrew/opt/fzf/bin:/Users/nyeong/.local/bin
PWD=/Users/nyeong/Temp/chirp
SHELL=/bin/zsh
... 생략됨 ...
```

### `/tmp` 아래에 `missing`이라는 디렉토리 만들기

```
$ mkdir /tmp/missing
$ cd !$
```

`!$`는 마지막 실행한 명령어의 마지막 인자이다.

`/tmp` 디렉토리는 작은 임시 파일을 위한 디렉토리이다. 시스템에 따라 부팅/종료 시, 혹은 일정 시간이 지나고
초기화되기도 한다. [file-hierarchy(7)](https://man.archlinux.org/man/file-hierarchy.7) 읽으면 도움된다.

### `touch` 명렁어 살펴보기

```
$ man touch
$ tldr touch
```

`touch`는 파일의 접근/수정 시간을 변경하거나 파일을 생성하는 명령어이다.

`man` 명령어로 명령어에 대한 메뉴얼을 볼 수 있다.

`man` 명령어가 다소 장황스럽다면, `tldr` 명령어로 필요한 사용법만 빠르게 볼 수도 있다.

### `touch`로 `semester`라는 파일 만들기

```
$ pwd
/tmp/missing
$ touch semester
$ ls
semester
```
