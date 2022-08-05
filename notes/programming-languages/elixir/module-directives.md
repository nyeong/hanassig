# 모듈 지시자

Module Directives. 모듈을 합성하기 때문에 composition이라고 부르기도 하는 듯.

## alias

모듈에 별칭을 붙일 때 쓴다.

```elixir
defmodule Sangatsu.State do
  def new, do: "어쩌구"
end

# 아무것도 없다면
state = Sangatsu.State.new()

# alias를 쓴다면
alias Sangatsu.State
state = State.new()

# `as`와 함께 쓴다면
alias Sangatsu.State, as: S
state = S.new()
```

## import

다른 모듈의 함수와 매크로를 불러올 때 쓴다.

```elixir
# 다 불러오면
import Sangatsu.State
state = new()

# 불러올 함수 선택하기
import Sangatsu.State, only: [new: 0]
state = new()

import Sangatsu.State, expect: [other: 1]
state = new()
```

기본적으로 `import` 하지 않아도 `List` 모듈의 함수를 쓰는 데에는 지장이 없음. 다만 `List.duplicate`처럼 모듈을 명시해주어야함.

## require

해당 모듈이 컴파일 된 후에 불러옴

```elixir
require Sangatsu.State
# Sangatsu.State가 컴파일 된 후에 이 코드가 실행됨이 보장된다.
```

## use

해당 모듈의 콜백을 사용. 클래스 상속같은 느낌으로 쓴다.

```elixir
defmodule Sangatsu.State do
  defmacro __using__(_opts) do
    quote do
      # 어쩌고
    end
  end
end

defmodule MySangatsu.State do
  use Sangatsu.State
  # Sangatsu.State.__using__ 콜백이 실행되었음
end
```

## 참고

[Making Sense of Elixir Directives](https://github.com/rwdaigle/elixir-directives)
[alias, require, and import -- elixir Getting Started](http://elixir-lang.org/getting-started/alias-require-and-import.html)