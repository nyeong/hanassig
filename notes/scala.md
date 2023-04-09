---
title: 스칼라
description: 스칼라 프로그래밍 언어
date: 2023-03-10
tags:
---

## 왜

- JVM 언어를 써 본 적 없어서
- 강타입 구조적 언어를 써보려고
- 데이터를 다룰 때 주로 거론되기에
- 다른 언어에서 좋게 썼던 기능들이 있기에
  - 루비와 뭔가 비슷함
	- 엘릭서처럼 액터 모델이 주류임 (akka)
	- 러스트처럼 함수적 데이터 모델링이 가능
	- 하스켈처럼 타입 시스템이 있긴 함

## 도구와 생태계

https://docs.scala-lang.org/getting-started/index.html

`coursier`라는 읽기 힘든 이름의 도구를 사용한다.
JRE가 필요한데, 스칼라 버전에 따라 호환되는 JVM 버전이 정해져있다.

- `coursier`: 버전 관리자
- `scalac`: 컴파일러
- `scala`: REPL (정적 컴파일 언어인데도 REPL을 지원한다)
- `sbt`: 빌드 도구
- `scalafmt`: 코드 포맷터

2.x 버전과 3.x 버전이 있는데, 대부분의 코딩 저지 사이트와 책에서
2.x 버전만 다루고 있어서 2.x 설치

```bash
$ asdf install java openjdk-17.0.2
$ cs install scala:2.13.10 scalac:2.13.10
```

- [스칼라 표준 라이브러리](https://www.scala-lang.org/api/current/)

## 타이핑 모델

정적이고 강타입이고 명목적이며 대부분의 값들이 객체이다.

```scala
if (Nil) println("true")
error: type mismatch;
found   : collection.immutable.Nil.type
required: Boolean
```

- 스칼라, 러스트: 참/거짓 판별은 오직 Bool만 가능함
- 루비, 엘릭서: `nil`, `false`는 `false`로 평가되고 나머지는 `true`임
- C, 파이썬: 맥락에 따라 `false`로 평가되는 값이 있음 (`0`, `null`, `[]` 등)

루비와 비슷하게 기본 자료형도 객체이고, 기본 연산자도 메소드다.[^1]

[^1]: https://www.scala-lang.org/api/current/scala/Int.html

다만 기본 자료형이 `abstract`로 선언되어있고 세부 구현이 숨겨져 있는 것을 보면
아마 컴파일 단계에서는 원시타입으로 바뀌는 것 같다.


```scala
// 1 + 1이라는 건
1 + 1

// 1이라는 Int 클래스의 인스턴스가 1을 인자로 `+`라는 메소드를 호출하는 것
1.+(1)
```

```ruby
# 루비도 기본 자료형이 객체이고 +, - 등 연산자도 메소드이다.
3.class
# => Integer
3.methods.include? :+
# => true
```

재밌게도 `def +(x: String): String`, 그러니까 `Int`와 `String`의 합연산이
정의되어 있어 보기처럼 작동은 하는데, 이 메소드는 2.13.0부터 deprecated 됐다.
그런데 반대로 `String`에서 `Int`를 더하는 연산은 deprecated 되지 않았는데,
`java.lang.String`을 쓰기 때문인 것 같다.

`java.lang` 아래의 모듈들은 자동으로 import한다. `String`도 사실은
`java.lang.String`이다.

```scala
3 + ".14"
val res: String = "3.14"

"4" + 2
val res: String = "42"
```

`Int + String`이 s-보간법 때문에 deprecated 되는 것 같은데, 같은 이유라면
항의 순서가 뒤바뀐 `String + Int`도 deprecated 되어야 하겠지만 JVM에 귀속된
메소드라 유지되는 것 같다.

루비의 중위 연산자는 특수한 경우이고 별도로 선언이 불가능하다.
엘릭서에서는 선언은 가능하나, 컴파일러가 인식할 수 있는 연산자가 정해져
있다.[^2]

[^2]: https://hexdocs.pm/elixir/1.14.3/operators.html#defining-custom-operators

그에 비해 스칼라는 중위 연산자 자체가 문법 설탕이라 아래의 짓거리가 가능하다.

```scala
case class MyBool(x: Boolean) {
	def and(that: MyBool): MyBool = if (x) that else this
}

// 보통은 이렇게 쓰겠지만
MyBool(true).and(MyBool(true))

// 이렇게 써도 알아먹는다
MyBool(true) and MyBool(true)
```

변수 선언은 `val` 혹은 `var`로 가능하다. `val`은 불변 변수이고 `var`은 가변
변수이다. 타입은 `: Type` 구문으로 명시하고, 유추 가능하면 생략할 수 있다.

```scala
val value = 4
var variable = 4
```

다행히 재할당(혹은 가리기(*shadowing*))이 가능하다. `val`로 같은 이름을 여러번
선언할 수 있다. 자바스크립트는 `const`로 선언하면 이게 안 되어서 불편하다.

```scala
val value = 3
val value = doSomethingWith(value)
```

```js
const value = 10
const value = doSomethingWith(value)
// Uncaught SyntaxError: Identifier 'value' has already been declared
```

불변과 가변 선언을 갈라놓은 언어들은 함정이 있다. 불변의 의미가 두가지이기
때문이다.

1. 객체의 재할당이 불가능하다
2. 객체의 재할당도 불가능하고 객체 값의 변경도 불가능하다

1번인 언어들은 객체가 같음은 보장되지만, 객체가 불변임은 보장되지 않는다.
값의 불변성을 위해서는 `freeze` 처리를 따로 해주어야 한다.

```js
const config = { url: 'https://example.com' }

// config와 Object 사이의 할당 관계 자체는 변하지 않았다.
config.url = 'https://bad-url.com'

// 이렇게 해야 불변성이 보장된다.
Object.freeze(config)
```

2번인 언어는 불변으로 선언만 하면 어떤 변수가 가리키는 대상이 바뀌지 않고,
대상 자체의 값도 변하지 않는 것이 보장된다.

```rust
let map = HashMap::new();
// 아래의 코드는 컴파일이 안된다.
// `insert` 메소드는 `(&mut HashMap<K, V>, K, V) -> Option<V>` 타입이고,
// `map`은 `mut`가 아니기 때문에 `&mut`로 빌릴 수가 없다.
map.insert(37, "a");
```

스칼라는 1번인 언어이다. 대신 가변 자료구조와 불변 자료구조를 구분하여 이를
타입으로 명시했다.
가변 자료구조로 선언하면 `val`로 선언하더라도 불변이 보장되지 않는다.

```scala
val arr = Array(1, 2)

// 업데이트가 가능하다.
arr.update(0, 42)
```

```scala
// 이렇게는 가능하다.
// arr이 가리키고 있던 List가 갖고 있는 값이 바뀐 것이 아니라
// arr에 업데이트된 List가 재할당된다
var arr = List(1, 2)
arr.updated(0, 42)

// 이렇게는 재귀적인 값 참고라고 불가능하다
val arr = List(1, 2)
val arr = arr.updated(0, 42)
```

## 자료구조

LISP 계열의 구조적 타이핑 언어들은 표준 자료구조 몇 개를 열심히 돌려써먹는다.
따라서 자료구조의 리터럴 표현도 간략하고 특징적이다.

```elixir
tuple = {1, 2}
list = [1, 2]
tuple_in_list = [a: 2, b: 4]
map = %{:a => 2, :b => 4}
function = fn x -> x end
custom_type = %CustomType{field: value}
```

스칼라는 반대로 대부분의 자료구조는 리터럴이 없고 열심히 타입을 명시해야한다.
대신 자료구조가 풍부하며 리터럴이 일관적이다.

위에서 얘기한 대로 가변 자료구조와 불변 자료구조를 구별하기도 한다.

```scala
val tuple: (String, Int) = ("localhost", 80)
val list: List[Int] = List(1, 2, 3, 4, 5)
val array: Array[Int] = Array(1, 2, 3, 4, 5)
val set: Set[Int](1, 2, 3, 4, 5)
val map: scala.collection.immutable.Map[String,Int] = Map("a" -> 1)
val function: Any => Any = (x: Any) => x
```

### List

랜덤 엑서스가 가능하고, 동종 자료만 담을 수 있고, 순서가 보장되며 불변이다.

```scala
val l = List("one", "two", "three")
```

동종 자료만 담을 수 있다.
서로 다른 자료형을 담고자 하는 경우, 이에 대한 타입을 새로 선언하거나 `Any`를
써야한다. 스칼라 3에서는 합타입을 지원하므로 편하게 합타입으로 처리하면 된다.

```scala
val l: List[Any] = List("one", "two", 3)

// 스칼라 3의 경우
val l: List[String | Int] = List("one", "two", 3)
```

### Set

순서가 보장되지 않으며 불변이다.

### Range

```scala
val res: scala.collection.immutable.Range.Inclusive = 1 to 10
val res: scala.collection.immutable.Range = 1 until 10
```

## 제어구조

제어구조의 조건문에는 `Boolean` 타입만 들어갈 수 있다.

- `while`
- `for`
- `foreach[U](f: (T) => U): Unit`

