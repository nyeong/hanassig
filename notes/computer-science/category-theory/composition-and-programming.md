# 합성과 프로그래밍

## 카테고리

```
+----------+  f  +----------+  g  +----------+
| object a |---->| object b |---->| object c |
+----------+     +----------+     +----------+
     |               g∘f               ^
     +---------------------------------+
```

카테고리는 대상(*object*)와 사상(*morphism*)으로 이루어져있다. 위 그림에서
네모는 대상, 화살표는 사상이다. 관례적으로 대상과 사상 모두 소문자로 쓰고,
사상은 수학 표기로 아래와 같이 쓴다.

$$
f: a \rarr b
$$

프로그래밍 언어에서는 타입을 대상으로, 함수를 사상으로 볼 수 있다.
아래의 하스켈, 엘릭서 코드의 함수 `f`를 위의 사상 $f$로 볼 수 있다.

```haskell
f :: a -> b
```

```elixir
@spec f(a) :: b
````

## 합성

사상을 합치는 것을 합성(*composition*)이라고 하며, 카테고리 이론의 핵심이다.
위 그림에서 대상 $a$에서 나온 화살표를 따라가면 대상 $c$까지 도달할 수 있다.
이를 아래처럼 작은 원으로 표기하고 "g after f" 라고 읽는다.

$$
g \circ f
$$

일반적인 언어에서는 아래와 같이 볼 수 있다:

```rust
fn g_after_f(obj: A) -> C {
  g(f(obj))
}
```

하스켈 같은 일부 언어는 언어 자체에서 함수의 합성을 지원한다. 아래의 두 줄은
동일하다:

```haskell
g . f object
g(f(object))
```

실제로 동작할 때에는 가장 오른쪽의 `f`부터 연산을 시작하기 때문에 시각적으로
헷갈릴 수 있다. 이에 엘릭서 같은 일부 언어는 아래와 같은 함수의 합성을 지원한다.
보통은 `pipe operator` 라는 이름으로 지원한다.

```elixir
f(object) |> g()
```

프로그램의 합성을 상상해도 좋다. git 디렉토리에서 커밋 목록을 출력하는 프로그램
`git log`와 문자열에서 줄 수를 세는 프로그램 `wc -l`을 합성하여 커밋의 수를
출력하는 프로그램으로 바꿀 수 있다:

```bash
git log --oneline | wc -l
```

사상의 합성은 반드시 아래의 두 조건을 만족해야한다.

- 합성은 결합법칙이 성립한다.
  $a \xrightarrow f b \xrightarrow g c \xrightarrow h d$에 대하여 아래가
  만족한다:
  $$
  h \circ (g \circ f) = (h \circ g) \circ f
  $$

- 모든 대상에 대해 항등 사상(*identity morphism*)이 존재한다. 항등 사상은
  $id_a: a \rarr a$와 같은 꼴이며 따라서 모든 사상 $f$에 대해 아래가 성립한다:
  $$
  id_b \circ f = f \circ id_a = f
  $$
  
프로그래밍 언어에서는 합성을 아래와 같이 볼 수 있다:

```haskell
f :: a -> b
g :: b -> c
h :: c -> d
-- f, g, h에 대하여 아래의 두 합성은 동일하다.
h . (g . f)
(h . g) . f
```

```elixir
@spec f(a) :: b
@spec g(b) :: c
@spec h(c) :: d

# f, g, h에 대하여 아래의 두 합성은 동일하다.
(f(a) |> g()) |> h()
f(a) |> (g() |> h())
```

항등사상의 경우 많은 언어에서 기본 구현으로 구현되어 있다. 하스켈의 경우 [기본
함수로 구현](https://hackage.haskell.org/package/base-4.17.0.0/docs/Prelude.html#v:id)되어 있다.
구현도 간단하다:

```haskell title="Prelude"
id :: a -> a
id x = x

f . id == f
id . f == f
```

엘릭서도 `Function.identity/1`로 구현되어 있다. 이렇게 표준으로 구현되어 있으면
고차 함수(*high order function*)에서 간편하게 쓸 수 있다.

```elixir title="Function.identity/1"
@spec identity(value) :: value when value: var
def identity(value), do: value

iex> Enum.group_by('abracadabra', &Function.identity/1)
%{97 => 'aaaaa', 98 => 'bb', 99 => 'c', 100 => 'd', 114 => 'rr'}
```

흔히 함수형이라 불리는 언어에 외에도 많은 언어에서 항등함수를 구현해두었다.
[러스트](https://doc.rust-lang.org/std/convert/fn.identity.html) 같은 시스템
프로그래밍 언어부터 [루비](https://ruby-doc.org/core-3.1.2/Object.html#method-i-itself)
같은 스크립트 언어까지 고차 함수를 많이 활용하는 언어에서 자주 구현되어있다.

```rust title="std::convert::identity"
pub const fn identity<T>(x: T) -> T {
    x
}
```

## 합성과 프로그램

프로그램은 분해와 조합으로 만들어진다. 프로그램은 어떤 문제를 해결하기 위해
존재하고, 프로그래머는 이를 쪼개어 작은 문제로 바꾼다. 문제가 충분히 작아졌다면
이를 해결하고 합성하여 다시 큰 프로그램을 만들어낸다.

좋은 코드는 구현부보다 결합부가 느리게 늘어난다. 구현부는 구현하고 나면
그 디테일은 잊어도 된다. 다른 것들과 어떻게 상호작용하는 지만 알면 된다.
