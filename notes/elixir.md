---
title: 엘릭서
description: 글 설명
date: 2023-03-14
tags:
---

## 이상한 점

혹은 아쉬운 점

### 후행 쉼표를 허용하지 아니함

trailing comma, 즉 후행 쉼표가 허용되지 않는다. 자료구조 끝에 쉼표를 쓸 수 없다!

```elixir
defp deps do
    [
      # ...
      {:argon2_elixir, "~> 3.0"},
      {:guardian, "~> 2.0"}
      #                    ^ 여기! 쉼표 넣고 싶어!!
    ]
  end
```

만약 밑에 의존성이 추가된다면 마지막 튜플 뒤에도 쉼표를 붙여야 하기 때문에
두 줄을 고쳐야한다. diff로 보면 아래와 같을 것이다.

```diff
-     {:guardian, "~> 2.0"}
+     {:guardian, "~> 2.0"},
+     {:jason, "~> 1.2"}
```

trailing comma가 허용되면 `,`를 미리 붙여도 되기 때문에 아래처럼 깔끔하게,
정말 고친 것만 볼 수 있다:

```diff
      {:guardian, "~> 2.0"},
+     {:jason, "~> 1.2"},
```

모든 줄이 구조적으로 동일하기 때문에 순서를 바꿀 때에도 편리하다. 리스트 내의
항목을 정렬이라도 해서 `,` 있는 줄이 위로 올라가면 찾아서 `,` 추가하고, 가장
마지막줄은 다시 지워줘야한다.

optional trailing comma를 지원하면 그럴 필요가 전혀 없다.

자바스크립트(ES5)나 러스트, 파이썬 같은 언어에서는 trailing comma를 지원한다.

SQL이나 ML 계열 언어에서는 쉼표를 오히려 앞에 쓰기도 한다. leading comma라고
해야할까? 아래와 같은 코딩 스타일이 종종 있다:

```haskell
deps :: List (Html msg)
deps =
    [ ("argon2_elixir", "~> 3.0")
    , ("guardian", "~> 2.0")
    , ("jason", "~> 1.2")
    ]

-- 선행 쉼표를 허용하지는 않는다. 허용 한다면 아래처럼 적을 수도 있을텐데.
deps =
    [
    , ("argon2_elixir", "~> 3.0")
    , ("guardian", "~> 2.0")
    , ("jason", "~> 1.2")
    ]
```

### 익명 함수

정확히는 변수에 할당된 함수를 호출하는 과정이 번잡스럽다.

```elixir
# `def`로 함수를 정의하고 호출할 때에는 아무 문제가 없다
def add(x, y), do: x + y
add(1, 2)

# 익명 함수를 변수에 할당하고 호출하려면 `.`을 찍어야 한다.
add = fn x, y -> x + y end
add.(1, 2)

# 기명 함수를 변수에 할당하고 출력할 때에도 `.`을 찍어야 한다.
add = &+/2
add.(1, 2)
```

`add`를 변수로써 다룰 때와 함수로써 호출할 때를 구별하기 위하여 `.`을 찍어야
한다.

참고: [Anonymous Function and the Dot](https://ragiragi.github.io/2019/11/01/anonymous-function-and-the-dot/)

### iex에서 바로 함수를 정의할 수 없음

`iex`에서 `def`로 함수를 정의하려고 하면 모듈에서 하시오! 하며 거부한다.

루비는 `irb`에서 선언한 것들을 모듈로 감싸주던 것 같은데 잘 기억 안난다.

```elixir
iex> def sum(a, b), do: a + b
** (ArgumentError) cannot invoke def/2 outside module
    (elixir 1.14.2) lib/kernel.ex:6387: Kernel.assert_module_scope/3
    (elixir 1.14.2) lib/kernel.ex:5084: Kernel.define/4
    (elixir 1.14.2) expanding macro: Kernel.def/2
    iex: (file)
```

### arity?

함수를 다룰 때 `arity`, 차수를 중요하게 다룬다. 어떤 함수를 특정하기 위해서는
함수 이름 + 차수가 필요하다.

```elixir
def some_function(a)
def some_function(a, b)

&some_function/1
&some_function/2
```

### 패턴 매칭으로 함수 분리

엘릭서에서는 함수의 인자를, 선언부부터 패턴매칭 할 수 있다.
이를 이용하여 어떤 인자가 넘어오냐에 따라 아예 다른 함수 몸체를 호출한다.
그런데 실질적으로 다른 동작을 함에도 불구하고 같은 함수 취급을 받는다.

아래처럼 같은 맥락을 다루는 경우라면 문제가 없지만...:

```elixir
@spec elevator(integer()) :: String.t()
def elevator(1), do: "Go to 1st floor"
def elevator(2), do: "Go to 2nd floor"
def elevator(3), do: "Go to 3rd floor"
def elevator(a), do: "Go to #{a}th floor"
```

이게 타입 시스템과 물리면 분석하기 어려워진다. 아래의 `negate/1` 함수의 예를
보자.

```elixir
@spec negate(x :: integer() | boolean()) :: integer() | boolean()
def negate(x) when is_integer(x), do: -x
def negate(x) when is_boolean(x), do: not x
```

여기서 선언한 `negate/1` 함수는
`negate(1) = -1`이며 `negate(true) = false`로 상식적이고 예측 가능한 함수이다.

그러나 타입만 보면 `integer() | boolean()`을 받아서 `integer() | boolean()`을
반환하는 함수이므로 `integer() -> booelan()` 혹은 `booelan() -> integer()`인
경우도 (타입만 본다면) 있을 수 있다.

<figure>
	<img src="/assets/elixir-negate-function.png" />
	<figcaption>ElixirLS가 분석한 negate 함수의 타입</figcaption>
</figure>

```elixir
# 인간이 볼 때, `negate`는 `integer -> integer | boolean -> boolean`이지만
# 현재 엘릭서의 타입 시스템으로는 `integer | booelan -> integer | boolean`이다.

res = negate(3)

# 따라서 사람에게 res가 `integer`임은 당연하고, 바로 알 수 있지만
# 정적 분석 도구는 res가 `integer | boolean`일 것으로 예측한다.
```

엘릭서에서 자주 쓰는 `GenServer`에서 쓰이는 디자인 패턴을 보면 해당 모듈이
서버로서 받는 요청을 `handle_call`, `handle_cast` 콜백을 구현함으로서
처리한다. 아무리 많은 콜백을 만들더라도 결국은 `handle_call/3`, `handle_cast/2`
두 개의 함수만 남게 된다.

이러한 프로그램이 엘릭서 코드를 분석하기 어렵게 하며, 도구의 지원을 받기 어렵게
하는 것 같다.

아래는 엘릭서에서 자주 쓰는 `GenServer` 패턴이다.

```elixir
defmodule Stack do
  use GenServer

  @impl true
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  @impl true
  def handle_cast({:push, element}, state) do
    {:noreply, [element | state]}
  end
end

{:ok, stack} = GenServer.start_link(Stack, [])
GenServer.call(stack, :pop)
GenServer.cast(stack, {:push, :value})
```

스택에서 값을 꺼내지 않고 제일 위의 값을 확인하는 `peek` 연산을 구현한다고 하자.
그러면 `handle_call`의 첫번째 인자가 `:peek`인 특수한 경우로서 처리하게 된다:

```elixir
# 구현
def handle_call(:peek, _from, [head | _] = state), do: {:reply, head, state}

# 사용
top_of_stack = GenServer.call(stack, :peek)
```

`handle_call` 함수는 실질적으로 다른 맥락에 따라 다른 동작을 하지만 단 하나의
함수이며, 처리해야하는 경우가 많아질 수록 복잡한 타입을 갖게 되어 분석이
어려워 질 것이다.

엘릭서 코어팀은 집합 기반 타입 시스템을 도입하여 이를 해결하고자 하고 있다.

https://elixir-lang.org/blog/2022/10/05/my-future-with-elixir-set-theoretic-types/

### Typespec

컴파일 언어이면서 동적 타입 시스템인 것이 일단 독특하다.
생각 외로 이런 언어가 많긴 하다. Clojure도 그렇고, CPython도 내 기억으론
실행 전에 바이트코드로 컴파일된다.

타입을 명시할 수 있는 시스템이 언어에 내장되어 있긴 하다.
[Typespecs](https://hexdocs.pm/elixir/typespecs.html)라고 부른다.
얼랭 때부터의 전통인 것 같다. 얼랭도 동적 타입 언어이면서 타입을 명시할 수 있는
[Erlang Type Language](https://www.erlang.org/doc/reference_manual/typespec.html)을
제공한다.

사소하게 불편한 점이 있는데:

1. 구조체의 타입은 타입스펙으로 별도로 선언해주어야함.
2. 구조체는 모듈 이름을 따르면서, 구조체의 타입은 그렇게 할 수 없음(`t()`).
3. 타입 표시에 자꾸 괄호(`()`)를 붙여야 함.

아래는 웹 애플리케이션을 다룰 때 주로 쓰는 `Plug.Conn` 객체의 구현의 일부이다. 구조체를 다룰 때 아래처럼 `defstruct`에는 필드와 초기값을 선언하고, 필요하다면 `@type`으로 그에 대한 타입을 덧붙여준다.

```elixir
defmodule Plug.Conn do
  defstruct adapter: {Plug.MissingAdapter, nil},
            assigns: %{},
            body_params: %Unfetched{aspect: :body_params}
            # 이외의 필드는 숨김

  @type t :: %__MODULE__{
    adapter: adapter,
    assigns: assigns,
    body_params: params | Unfetched.t()
    # 이외의 필드는 숨김
  }
end
```

위에서 보는 것처럼 각 필드에 대한 타입을 따로, 기본값을 따로 선언해주어야 한다.

고칠 때에도 두 번 고쳐야 하는데... 생각해보니 보통의 언어들도 초기값을 정의하려면 그런 것 같기도 하고?

하지만 구조체는 모듈을 기준으로 선언하면서, 타입은 모듈 이름으로 선언 못하고,
`t`를 붙여줘야하는 건 확실히 이상하고 어색하다. 거의 표준처럼 쓰고 있지만
표준은 아닌 듯.

그래서 타입을 선언할 때 `String`을 `String`이라고 부를 수 없다.

```elixir
defmodule String do
  # Typespec으로 String은 이렇게 선언한다.
  @type t :: binary
end

# `ends_with?`이라는 함수를 만드려면, 아래와 같이 `String.t()`로 선언해야 한다.
@spec ends_with?(String.t(), String.t()) :: boolean()

# 이게 더 자연스럽지 않나??
@spec ends_with?(String, String) :: boolean()
```