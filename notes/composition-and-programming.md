---
title: 합성과 프로그래밍
---

## 카테고리

```
+----------+  f  +----------+  g  +----------+
| object a |---->| object b |---->| object c |
+----------+     +----------+     +----------+
     |               g∘f               ^
     +---------------------------------+
```

카테고리는 대상(_object_)와 사상(_morphism_)의 모음이다.
위 그림에서 네모는 대상, 화살표는 사상이다.
위의 사상 $f$는 아래와 같이 표기한다. 대상 $a$에서 대상 $b$로 가는 사상이라는
뜻이다.

$$
f: a \rightarrow b
$$

위의 그림에서 사상 $f$와 $g$를 순서대로 따라가면 대상 $a$에서 대상 $c$로 도달할
수 있다. 이를 합성(_composition_)이라고 하며 $g \circ f$라고 쓴다.

- 합성은 결합법칙(_associativitiy_)이 성립한다. 무엇을 먼저 합성하든 결과가 같아야한다.
  $a \xrightarrow f b \xrightarrow g c \xrightarrow h d$에 대하여 아래가
  만족한다:

  $$
  h \circ (g \circ f) = (h \circ g) \circ f
  $$

- 모든 대상에 대해 항등 사상(_identity morphism_)이 존재한다. 항등 사상은
  $id_a: a \rightarrow a$와 같은 꼴이며 따라서 모든 사상 $f$에 대해 아래가 성립한다:
  $$
  id_b \circ f = f \circ id_a = f
  $$

위의 조건을 만족하기만 하면 무엇이든 대상과 사상, 즉 카테고리로 볼 수 있다.

## 카테고리로서의 프로그래밍 언어

프로그래밍 언어에서는 타입을 대상으로, 함수를 사상으로 볼 수 있다.
아래의 하스켈, 엘릭서 코드의 함수 `f`를 위의 사상 $f$로 볼 수 있다.

```haskell
f :: a -> b
```

```elixir
@spec f(a) :: b
```

프로그래밍 언어를 카테고리로 보려면 합성이 가능해야하고, 합성에 대해 결합법칙과
항등사상이 존재해야한다.

먼저 합성이다. 이미 존재하는 $f$, $g$를 합성하여 새로운 함수를 만들고 이름을
붙일 수 있다.

```rust
fn f(obj: A) -> B;
fn g(obj: B) -> C;
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

프로그램의 함수의 합성도 결합법칙을 만족한다. 합성을 할 때에 무얼 먼저 합성하든
결과는 동일하다:

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

## f, g, h에 대하여 아래의 두 합성은 동일하다.
(f(a) |> g()) |> h()
f(a) |> (g() |> h())
```

모든 대상에 대한 항등사상도 쉽게 만들 수 있다. 동적 언어의 경우 받은 값을 그대로
돌려주기만 하면 된다.[^1]

[^1]: https://hexdocs.pm/elixir/main/Function.html#identity/1

```elixir
@spec identity(value) :: value when value: var
def identity(value), do: value
```

제네릭을 지원하는 언어는 이를 이용하여 만들 수 있다[^2]:

[^2]: https://doc.rust-lang.org/std/convert/fn.identity.html

```rust
pub const fn identity<T>(x: T) -> T {
  x
}
```

당연히 하스켈에서도 쉽게 정의할 수 있다. [^3]

[^3]: https://hackage.haskell.org/package/base-4.17.0.0/docs/Prelude.html#v:id

```
id :: a -> a
id x = x

f . id == f
```