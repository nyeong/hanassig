---
title: zsh
slug: zsh
---

## 이상한 괄호쌍

쉘을 쓰다 보면 너무나도 다양한 괄호쌍이 나온다. 헷갈려서 정리했다.

대괄호, 중괄호, 소괄호를 영어로는 각각 brackets, curly braces, parenthese라고
한다.

- 단일 대괄호(`[ ]`): 조건 표현문. POSIX 표준[^1]
- 이중 대괄호(`[[ ]]`): `[`의 개선판.
- 중괄호(`{ }`): 중괄호 확장문(_brace expansion_)[^3]
- 단일 소괄호(`( )`): 배열 표현.
- 이중 소괄호(`(( ))`): 산술 표현문.[^2]
- 산술 확장문(`$[ ]`): 더 이상 쓰지 않는다.
- 변수 확장문(`${ }`)
- 명령어 대치문(`$( )`): 명령어를 실행하고 그 결과로 값을 대치한다.
- 산술 확장문(`$(( ))`)

[^1]: https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html
[^2]: https://www.gnu.org/software/bash/manual/html_node/Shell-Arithmetic.html
[^3]: https://www.gnu.org/software/bash/manual/html_node/Brace-Expansion.html

### 대괄호

`[ ]`(단일 대괄호, _single bracket_), `[[ ]]`(이중 대괄호, _double bracket_)
모두 조건 검사에 쓴다.

`[ ]`는 조건 검사 명령어이다. 보통 `/bin/[`에 위치하며 `/bin/test`와 동치이다.
POSIX 호환 문법이다.[^4]

[^4]: https://pubs.opengroup.org/onlinepubs/9699919799/utilities/test.html

`[[ ]]`는 확장 문법이다. korn, bash, zsh 등의 쉘에서 폭넓게 사용한다. 해당 쉘을
쓴다면 `[[ ]]`만 알아도 충분하다.

자세한 사용법은 [Bash Conditional Expressions] 참고.

[bash conditional expressions]: https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html

`$[ ]`(산술 대치문, _arithmetic expansion_)은 `$(( ))`로 대치되어 현재는 쓰지
않는다.[^5]

[^5]: https://wiki.bash-hackers.org/scripting/obsolete

### 중괄호

`{ }`(중괄호, _braces, curly braces_)는 문자열의 리스트를 만들 때 쓴다.

아래의 두 명령어는 똑같다. `{ }`를 이용하여 간편하게 줄여 쓸 수 있다.

```bash
$ mv -i lib/user/{accont,account}.ex
$ mv -i lib/user/accont.ex lib/user/account.ex
```

아래와 같이 범위를 지정할 수도 있다. 이는 문자열도 가능하다.

```bash
$ mkdir test_dir_{00..99..2}
$ touch {가..힣} # 왜 이런 짓을...?
```

`${ }`(변수 확장문, _parameter expansion_)을 쓰면 변수를 결과값으로
대치(_substitute_)할 뿐 아니라, 여러가지 옵션으로 확장할 수 있다.

변수와 뒤에 오는 문자열을 구분해야 할 경우 `$var` 대신 쓸 수 있다.

```bash
$ DIR_PREFIX=hello
$ echo $DIR_PREFIX_world
##
$ echo ${DIR_PREFIX}_world
## hello_world
```

옵션으로 확장하면 다양한 기능을 함께 쓸 수 있다. `${var=str}` 문법은 `var`
변수가 정의되어 있으면 그걸 쓰고, 정의되어 있지 않다면 `var`에 `str`을 대입하고
`str` 값을 결과로 쓴다. 아래의 코드는 `$EDITOR` 변수가 정의되어 있으면 해당
편집기로 `config` 파일을 열고, 아니라면 `vim`으로 여는 명령어이다.

```bash
$ ${EDITOR=vim} config
```

그 외의 옵션은 [Shell parameter Expansion] 참고.

[shell parameter expansion]: https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html

### 소괄호

`( )`(단일 소괄호, _single parentheses_)는 배열을 만들 때 쓴다.

```bash
$ array=(1 2 3)
$ $array
## 1 2 3
```

`(( ))`(이중 소괄호, _double parentheses_)는 산술 연산에 쓴다.

```bash
$ i=10
$ i+=10
## i = 1010

$ i=10
$ ((i += 10))
## i = 20
```

`$(( ))`(산술 확장문, _arithmetic expansion_)은 산술 계산 후 결과값으로
대치된다.

```bash
$ echo ((i += 10))
## zsh: no maches found: ((i += 10))
$ echo $((i += 10))
## 30
```

## 팁

### 특정 명령어가 있는지 확인하기

`(( $+commands[foobar] ))` 쓰면 된다.

[Speed Test: Check the Existence of a Command in Bash and Zsh][check-speed-test]

[check-speed-test]: https://www.topbug.net/blog/2016/10/11/speed-test-check-the-existence-of-a-command-in-bash-and-zsh/

- `type foobar &> /dev/null`
- `hash foobar &> /dev/null`
- `command -v foobar &> /dev/null`
- `which foobar &> /dev/null`
- `(( $+commands[foobar] ))`

아래와 같이 쓸 수 있다.

```bash
export EDITOR=vi

if (( $+commands[vim] )); then
  export EDITOR=vim
fi

if (( $+commands[helix] )); then
  export EDITOR=helix
  alias hx='helix'
fi
```
