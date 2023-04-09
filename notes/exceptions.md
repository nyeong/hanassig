---
title: 예외를 처리하는 방법
description:
date: 2023-02-24
tags:
---

## 오류를 반환하기

### 특수한 값으로 반환하기

C언어에서는 파일을 열 때 `fopen` 함수를 쓴다. 이 함수는 힙에 파일 객체를 생성하고 포인터를 반환하는데, 파일 열기에 실패하였다면 널 포인터를 반환한다.[^1]

[^1]: https://cplusplus.com/reference/cstdio/fopen/

```c
#include <stdio.h>

int main() {
  FILE * file = fopen("somefile", "r");
  if (file == NULL) {
    // handle error
  }
  
  // do something with `file`
}
```

### 평범한 값으로 반환하기

성공했을 때에는 성공값을 반환하고, 오류가 났을 때에는 오류값를 반환한다. 둘의 경우를 구분하기 위하여 구분자를 붙이거나 순서를 달리한다.

```go
// go의 경우. 첫번째 반환값은 성공값이고 두번째 반환값은 오류값이다.
func Divide(a, b int) (int, error)

res, err := Divide(3, 0)
```

```elixir
# elixir의 경우. `:ok`와 함께 반환되면 성공값이고, `:error`와 함께 반환되면 오류값이다.
@spec divide(integer, integer) :: {:ok, integer} | {:error, :divide_by_zero}

case divide(3, 0) do
  {:ok, res} -> IO.puts("success!") 
  {:error, e} -> IO.puts("input new value")
end
```


### Result 모나드

```rust
enum Result<T, E> {
  Ok(T),
  Err(E)
}
```

## 오류를 던지기


## 참고

- Timur Doumler, [How C++23 changes the way we write code - Meeting C++ 2022](https://youtu.be/QyFVoYcaORg?t=2580)
