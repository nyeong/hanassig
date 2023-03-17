---
title: 모나드와 펑터와 어플리케이티브
slug: functor-applicative-monad
description: 함수형 삼대장을 아는 척 해보자
date: 2023-03-08
tags:
---

요약: 셋 다 합성을 쉽게 하기 위해서이다.

```haskell
class Monad m where
  (>>=)  :: m a -> (a -> m b) -> m b
  return :: a -> m a

class Functor f where
  fmap :: (a -> b) -> f a -> f b
  (<$) :: a -> f b -> f a

class (Functor f) => Applicative f where
    pure  :: a -> f a
    (<*>) :: f (a -> b) -> f a -> f b
```

![](../assets/완전이해.jpg)

## 모나드

이진트리 하나를 생각해보자. 어떤 노드는 그 밑에 왼쪽노드와 오른쪽노드가
있을 수도 있고, 없을 수도 있다.

```elixir
@type Node :: %{ left: Node | nil, right: Node | nil }

@spec left(Node) :: Node | nil
def left(node), do: node.left

@spec right(Node) :: Node | nil
def right(node), do: node.right
```

어떤 노드 `n`의 왼쪽 자식이 노드라면 그 노드도 자식이 있을 수 있다.
`n`의 왼쪽 자식의 오른쪽 자식을 구하려면 어떻게 해야할까?

그냥 `n |> left() |> right()`하면 직관적이어서 좋겠지만, `left()`에서 `nil`이
반환되는 경우를 생각해야 한다.

```
node |> left() |> right()
** (KeyError) key :left not found in: nil.
```

엘릭서스럽게 이 상황을 타파하는 간단한 방법은 저 두 함수가 `nil`을 받도록
고치는 것이다.

```elixir
@spec left(Node) :: Node | nil
def left(nil), do: nil
def left(node), do: node.left

@spec right(Node) :: Node | nil
def right(nil), do: nil
def right(node), do: node.right
```

함수를 고치지 않고 해결할 수 있을까? 패턴 매칭이나 `case`로 해결할 수 있겠지만,
구조가 깊어질 수록 표현하기 어렵다.

```elixir
# 패턴매칭
def left_right_node(%{left: %{right: lrnode}}), do: lrnode
def left_right_node(_), do: nil

# case
def left_right_node(node) do
	case node.left do
		%{left: left} ->
			right(left)

		_ ->
			nil
	end
end
```

`left/1`과 `right/1`을 파이핑하면 직관적으로 깊은 구조도 표현할 수 있다.
함수를 고치지 않고 파이핑 할 수 있을까? `nil`인 경우를 처리해주는 함수를
만들어 감싸주자.

```elixir
def bind(nil, _), do: nil
def bind(val, f), do: f.(val)

node |> bind(&left/1) |> bind(&right/1) |> bind(&right/1)
```

`apply/2` 함수 덕분에 `case`를 중첩하거나 구조를 직접 나열하지 않고
파이핑으로 직관적으로 알아볼 수 있게 되었다.

### 일반화하기

무엇이 문제였고, 어떻게 해결했는지 일반화해보자.

`left/1`, `right/1` 함수는 `Node`를 취하고 `Node`나 `nil`을 반환하는 함수이다.
`nil`이 반환되는 경우 때문에 다시 `left/1`, `right/1` 함수에 넣을 수 없었다.

```elixir
@spec left(Node) :: Node | nil
@spec right(Node) :: Node | nil
```

"`Node | nil`"은 유무를 나타내기 위해 `Node`를 확장한 타입이다.
이외에도 다양한 맥락에 의해 `Node`를 확장할 수 있다.

```elixir
# 유무를 나타내기 위해: Maybe monad, Option monad
@spec left(Node) :: Node | nil

# 실패까지 나타내기 위해: Result monad
@spec get_left_from_network(Node) :: {:ok, Node} | {:error, reason}

# 여러개가 있음을 나타내기 위해: List Monad
@spec children(Node) :: [Node]
```

이런 함수로 얻은 값을 `Node`에 취하려면 특수한 경우를 처리하고 순수한 `Node`를
얻어야 한다. 크게 네 가지 경우를 생각할 수 있다:

1. 함수가 직접 특수한 경우도 받도록 한다.
2. 내가 직접 처리해서 함수에 던져준다.
3. 처리해주는 함수를 쓴 후 그 결과를 함수에 던져준다.
4. `with`을 쓴다.

어떤 타입을 확장한 타입은 그 가짓수가 많다. 특별히 유용한 경우가 아니라면
매번 함수를 만들 때 이런 경우도 모두 처리하는 것은 어려울 것이다.

따라서 보통은 내가 직접 처리해서 함수에 던져주는 것이 나을 것이다.
엘릭서의 경우 함수 인자나 case를 통한 패턴매칭으로 손쉽게 처리할 수 있다.

```elixir
{:ok, content} = File.read(filename)
do_something(content)

# 에러도 처리하기
case File.read(filename) do
	{:ok, content} ->
		do_something(content)

	{:error, reason} ->
		handle_error(reason)
end
```

그러나 이런 제어구조를 빈번히 사용하면 가독성이 떨어진다. `Node`의 자식의
자식을 찾는 예시에서 처럼 제어구조가 중첩되면 읽기 어렵고 고치기 어렵다.

```elixir
case Accounts.get_user(id) do
	{:ok, user} ->
		case Accounts.update_user(user, name: "fantastic") do
			{:ok, updated_user} ->
				IO.puts("User updated!")
			{:error, reason} ->
				IO.puts("User can not be updated with #{reason}")
		end
	{:error, _} ->
		handle_not_found()
end
```

```elixir
def nil ~>> _, do: nil
def val ~>> f, do: f.(val)

node ~>> left() ~>> right() ~>> right()
```
