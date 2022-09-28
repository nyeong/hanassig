# 유닉스 신호

유닉스 신호를 사용하는 리눅스, macOS, BSD 계열 OS에 한정한 이야기이다.

각각의 프로세스들은 서로와, 그리고 운영체제와 **유닉스 신호**(*unix signal*)을
이용하여 소통한다. CLI에서 프로그램을 쓰다가 `Ctrl+C`를 눌러 종료할 때에도
유닉스 신호가 전달된다.

아래의 C 프로그램은 `SIGINT` 신호를 받을 때까지 대기하고, 받으면 종료한다.
일반적으로는 프로그램이 실행되고 있을 때 `Ctrl-C`를 눌러 신호를 보낼 수 있다.

```c
#include <signal.h> // signal function
#include <stdio.h>  // printf function
#include <unistd.h> // sleep function
#include <stdlib.h> // exit function

void handle_sigint(int signum) {
  printf("%d: SIGINT catched.\n", signum);
  exit(0);
}

int main() {
  signal(SIGINT, handle_sigint);

  while (1) {
    sleep(1);
  }
  
  return 0;
}
```

```bash
$ clang test.c
$ ./a.out
^C2: SIGINT catched.
```

신호는 기본적으로 프로세스를 인터럽트한다. 위의 C 예시에서 프로세스는
`while`문을 실행하고 있겠지만, 유닉스 신호를 받는 순간
`void handle_sigint(int)` 콜백부터 처리한다.

## 신호 보내기

유닉스 신호 전체는 `man signal`로 볼 수 있다.

주로 쓰는 유닉스 신호와 신호 번호(*signum*), 매핑된 단축키는 아래와 같다.
번호는 유닉스의 [macOS signal 메뉴얼][macos-signal]을 참고하였는데, 리눅스의
그것과 다를 수도 있다.

[macos-signal]: https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man3/signal.3.html

| 신호이름 | 번호 | 단축키 | 설명                           | 기본동작    |
|----------|--- --|--------|--------------------------------|-------------|
|`SIGHUP`  | 1    | 없음   | 신호 끊김(hang up)             |프로세스 종료|
|`SIGINT`  | 2    | Ctrl-C | 프로세스 인터럽트              |프로세스 종료|
|`SIGQUIT` | 3    | Ctrl-\ | 프로세스 종료                  |코어 덤프    |
|`SIGKILL` | 9    | 없음   | 프로세스 강제종료              |코어 덤프    |
|`SIGSTOP` | 17   | 없음   | 프로세스 멈춤 (무시할 수 없음) |프로세스 멈춤|
|`SIGTSTP` | 18   | Ctrl-Z | 프로세스 멈춤 (키보드로 발생)  |프로세스 멈춤|
|`SIGCONT` | 19   | 없음   | 프로세스 재개                  |신호 무시    |
|`SIGCHLD` | 20   | 없음   | 자식 프로세스의 상태가 바뀜    |신호 무시    |
|`SIGUSR1` | 30   | 없음   | 프로세스 재개                  |신호 무시    |

- 프로세스 종료(*terminate*): 프로세스의 작동을 멈추고 종료한다.
- 프로세스 멈춤(*stop*): 프로세스를 정지시킨다. `SIGCONT`로 다시 실행시킬 수
  있다.
- 코어 덤프(*create core image*): 프로세스를 종료(*terminate*)하고 메모리
  상태를 기록한다. 프로그램이 종료되었을 때 상태를 확인하고 재현할 수 있도록
  하기 위함이다.
  
### `SIGHUP`?

**sig**nal **h**ang **up**의 약어이다. *hang up*이 전화를 끊다라는 뜻인데,
전화선으로 

프로세스를 실행하고 있는 터미널이 종료되면 프로세스에게 `SIGHUP` 신호가
전달된다. 기본 동작은 종료이기 때문에 터미널을 종료하면 켜놓았던 프로세스는
다 종료된다. 이를 막으려면 `nohup` 명령어를 사용하면 된다.

### `SIGQUIT`과 `SIGKILL`의 차이

`SIGQUIT`은 프로세스에 멈춤 신호를 보내어 자식 프로세스나 메모리를 정리하도록
한다. 반면 `SIGKILL`은 강제로 종료해버린다. 그래서 문제가 생긴 프로세스를
강제 종료할 때에는 아래와 같이 `kill -9`으로 `SIGKILL` 신호를 보내어 강제로
종료한다.

```bash
$ kill -9 [pid]
```

### `SIGSTOP`과 `SIGTSTP`의 차이

둘 다 프로세스에 멈추라는 신호를 보낸다. `SIGTSTP`은 주로 `tty`를 통하여
키보드로 보내며 (보통 `ctrl-z`) 프로그램이 무시할 수 있는 반면 `SIGSTOP`은 
`kill`등의 명령어와 조합하여 신호를 보내며 무시할 수 없다.

프로세스가 멈추면 종료되는 것과는 다르게 일시중지된 상태로 현재 세션에
남아있는다.

```
# <c-z>를 눌러 SIGTSTP 신호 보내기
$ ruby test.rb
^Z
zsh: suspended  ruby test.rb

# `kill` 명령어를 이용하여 SIGSTOP 신호 보내기
$ ruby test.rb &
[2] 69330
$ kill -17 69330
[2]  + suspended (signal)  ruby test.rb

# 일시 중지된 작업 보기
$ jobs
[1]  - suspended  ruby test.rb
[2]  + suspended (signal)  ruby test.rb
```

이렇게 일시 중지된 작업들은 `fg` 명령어로 포어그라운드에서, `bg` 명령어로 
백그라운드에서 작업을 재개할 수 있다. 이대로 종료하고 싶다면 `kill` 명령어로
`SIGINT` 등의 신호를 보내면 된다.

### 프로그래밍 언어에서

### 러스트에서

러스트에서는 표준 라이브러리만으로는 유닉스 신호를 처리하기 힘들다.
표준 라이브러리로 `std::io::signal`이 있었으나, 처리를 위하여 운영체제에 의존한
런타임 라이브러리가 필요해서 삭제된 것 같다.[^1] [CtrlC]와 같은  외부
라이브러리를 이용하면 처리할 수 있다.

[^1]: https://github.com/rust-lang/rust/pull/17673
[CtrlC]: https://crates.io/crates/ctrlc

## 참고

- [Signal handling](https://rust-cli.github.io/book/in-depth/signals.html)
- [signal(7) - Linux manual page][unix-signal]

[unix-signal]: https://man7.org/linux/man-pages/man7/signal.7.html
