---
title: 타입은 집합이다
---

타입을 집합으로 생각해보자.

정수 타입 `i32`를 생각해보자. 보통 이 타입은 구간 $[-2^{31},2^{31} - 1]$에 속한
정수를 표현할 수 있다. 구간 내의 정수를 원소로, 타입 `i32`를 집합으로 볼 수
있다.

$$
\text{i32} = \{x\mid -2^{31}, \cdots, -1, 0, 1, \cdots, 2^{31} - 1\}
$$

`i32`를 인자로 취하는 함수를 생각해보자. 아래의 함수 `i32`는 수를 제곱해준다.
따라서 반환 타입도 `i32`이다.

```rust
fn square(n: i32) -> i32 { n * n }
```

이를 집합으로 생각해보자. 함수 $\operatorname{square}$는 $\text{i32}$를 취하여
$\text{i32}$를 반환하는 함수이다.

$$
\operatorname{square}: \text{i32} \rightarrow \text{i32}
$$

타입을 집합으로 생각하면 아래처럼 볼 수 있다:

- 값은 원소이다.
- 타입은 가능한 값들의 집합이다.
- 함수는... 함수이다. 집합의 함수가 그러하듯 어떤 타입을 다른 타입과 이어준다.

## 사실 집합은 아니다

그러나 프로그래밍 언어는 컴퓨터에 내리는 명령이고, 정의만으로 끝나는 것이 아니라
실제로 수행하는 작업의 나열이다. 어떤 때에는 작업이 끝나지 않을 수도 있다.
그리고 작업이 끝나지 않는 것을 미리 알 수 있는 방법은 없다.[^1]

[^1]: https://en.wikipedia.org/wiki/Halting_problem

```rust
fn some_function(arg: bool) -> bool;
// 이 함수가 정상적으로 `bool`을 반환하지 않을 수도 있다.
```

위의 함수가 정상적으로 `bool`을 반환한다는 것은 보장할 수 없다.
무한 루프에 빠질 수도 있고, 무한 재귀에 빠질 수도 있고, 예외가 발생할 수도
있고, 에러가 날 수도 있고, 프로그램이 강제 종료 될 수도 있다.
아니면 결과가 나오기 전에 컴퓨터가 폭발하여 사라질 수도 있다.

따라서 끝나지 않는 작업(_non-terminating computation_)을 표현하기 위하여
*bottom*이라는 값이 도입되었다. $\bot$으로 표기한다.
모든 타입은 `⊥`을 값으로 갖는다. 특정 타입을 반환할 때만 안전하리라는 보장이
없기 때문이다. 따라서 `bool` 타입은 `true`, `false`, `⊥`을 값으로 취한다.

`⊥`도 `bool` 타입이기 때문에 아래의 코드는 정상적으로 컴파일된다.
그리고 의도대로 `true`도 `false`도 아닌 `⊥`을 반환할 것이다.

```rust
fn some_function(_arg: bool) -> bool {
    panic!()
}
```

`⊥`의 존재로 프로그래밍 언어의 타입은 엄밀히 말하여 집합은 아니다. 그러나
`⊥`만 제외한다면 집합과 유사하기 때문에 집합으로 생각하여도 괜찮다.

## 타입은 집합이다

타입을 집합이라고 생각해도 괜찮다. 타입을 집합으로 생각하면 프로그램을 분석하기
쉬워진다.

프로그램이 옳은지 분석하고 검증하는 것은 어려운 일이다. 프로그램을 함수의
결합(_composition_)으로 생각하고, 유효한 결합인지 검증하는 것은 훨씬 쉽다.
또한 프로그래밍 언어는 각 언어 설계자의 취향과 의도에 따라 서로 다른 용어를
사용하는데, 이를 집합으로 봄으로써 동일한 언어와 용어로 분석할 수 있다.

### 공집합

공집합(_empty set_)은 아무런 원소가 없는 집합이다. $\varnothing$ 혹은 $\{\}$로
표기한다. 공집합에 대응하는 타입을 상상해보자.

```rust
enum EmptySet {}
let some_value: EmptySet = ???;
```

`EmptySet`이라는 타입은 존재하지만 그 타입에 속하는 값이 존재하지 않는다.
`EmptySet`을 인자로 취하는 함수를 상상해보자.

```rust
fn absurd(arg: EmptySet) -> T;
```

위 함수를 호출할 수 있을까? `EmptySet`을 인자로 취하기 때문에 값을 넘겨주어야
하지만 `EmptySet` 타입인 값은 존재하지 않는다. 따라서 위의 함수는 호출할 수 없다.

```rust
absurd(???); // 인자로 넘겨줄 값이 존재하지 않다.
```

`EmptySet`을 반환하는 함수는 만들 수 있을까? 얼핏보아서는 불가능할 것 같다.
반환하면 `EmptySet`의 원소를 메모리에 표현해야하는데, 존재하지 않는 것을 메모리에
표현할 수는 없다.

그럼에도 `EmptySet`을 반환하는 함수를 정의하고 실행할 수 있다. 말장난 같지만
끝나지 않는 작업을 $\bot$이라는 값으로 정의하였고, 모든 타입은 $\bot$을 원소로
갖기 때문에 공타입 `enum EmptySet {}` 또한 $\bot$을 원소로 취한다.

따라서 아래 함수는 정의할 수 있고, 컴파일되고, 실행할 수 있다.
아래가 바로 공타입을 반환하는 함수이다. 정말 대단해.

```rust
fn some_function() -> EmptySet {
    loop {}
}
```

러스트에서는 원시타입으로 [never](https://doc.rust-lang.org/std/primitive.never.html)가 정의되어 있으며 `!`[^1]로 표기하기 때문에
*bang-type*이라고도 부른다. 위의 `EmptySet`은 `!`로 대체할 수 있다.

대체 이걸 어디다 써먹는단 말인가? 위에서 보았듯이 공타입은 오로지 $\bot$, 즉
**반환이 없음**만을 그 값으로 취할 수 있다. 따라서 이를 표현하는 타입으로 활용할 수 있다.
문제가 있는 경우를 타입으로 표기함으로써 이를 타입 시스템에서 파악할 수 있다.

현재 프로세스를 종료하는 러스트 표준 함수 `std::process::exit`의 타입은 아래와 같다:

```rust title="std::process"
pub fn exit(code: i32) -> !
```

반환형이 `!`이기 때문에 이 함수가 실행되면 다음 작업을 실행할 수 없음을 알 수 있다.
덕분에 컴파일러가 아래처럼 실행 전에 미리 경고해줄 수 있다.

```rust
fn main() {
    std::process::exit(0);
//  --------------------- any code following this expression is unreachable
    println!("Hello, World!");
//  ^^^^^^^^^^^^^^^^^^^^^^^^^ unreachable statement
}
```

[^1]: https://rust-lang.github.io/rfcs/1216-bang-type.html

### 단위 집합

단위 집합(_unit set_)은 단 하나의 원소만을 갖고 있는 집합이다.
원소가 하나니까 싱글톤(_singleton_)이라고도 불리운다. 싱글톤 패턴의 그 싱글톤 맞다.

싱글톤 패턴은 어떤 클래스에 대한 인스턴스가 오직 단 하나만 존재하도록 하는
디자인 패턴이다. 아래의 예시에서 변수 `x`, `y`, `z` 모두 같은 싱글톤 인스턴스를
가리키고 있다. 인스턴스가 단 하나이기 때문에 싱글톤이라는 이름이 붙었다:

```java
class Singleton {
    private static Singleton instance = null;
    private Singleton() { /* initiating Singleton object */ }
    public static Singleton getInstance() {
        if (instance == null)
            instance = new Singleton();
        return instance;
    }
}

// in other methods...
Singleton x = Singleton.getInstance();
Singleton y = Singleton.getInstance();
Singleton z = Singleton.getInstance();
```

어떤 언어에서는 특별한 값을 나타내기 위해 단위 타입을 사용한다.
루비의 `true`, `false`, `nil` 등의 값은 `TrueClass`, `FalseClass`, `NilClass`의
유일한 값이다. 따라서 이들은 단위 타입이다.

```ruby
irb> true
=> true
irb> true.class
TrueClass
```

`TrueClass`의 원소는 ($\bot$을 제외하면) `true` 말고는 없다.

$$
\text{TrueClass} = \{\text{true}\}
$$

단위 타입은 사실 암묵적으로 정말 많이 쓰이고 있다. 아래의 예시를 통해 알아보자.
아래의 함수 `hello_world`는 아무 인자를 취하지 않고 `String`을 반환하고 있다.
아무것도 아닌 것을 인자로 취하는 공타입과는 구별된다.

```rust
// 인자를 취하지 아니함
fn hello_world() -> String { /* ... */ }
// 인자를 넘기지 않아도 실행된다
let hi = hello_world();

// 아무것도 아닌 것을 인자로 취하는 공타입과는 다르다
fn hello_world(arg: !) -> String { /* ... */ }
// 아무것도 아닌 것을 인자로 넘길 수는 없다...
let hi = hello_world(???);
```

정말 아무것도 취하지 않고 `String`을 반환한다면 사실상 `String`과
동일해야 한다. 그러나 `hello_world`는 `String`은 아니다.
아래의 예시는 타입 에러가 난다:

```rust
fn hello_world() -> String { /* ... */ }
let hello_string: String;

fn print_it(arg: &String);
print_it(&hello_world);  // mismatched types
print_it(&hello_string); // 문제 없음
```

`hello_world`는 그냥 `String`인 것이 아니라 **아무것도 아닌 무언가를 `String`으로
바꿔주는 함수**이다. 아무것도 아닌 무언가의 역할을 할 것이 있어야 하는데 이
암묵적인 역할을 단위 타입이 맡는다. 러스트에서는 이를 [`()`](https://doc.rust-lang.org/stable/std/primitive.unit.html)으로 표기하고
유닛이라고 읽는다. `hello_world` 함수를 인자로 받는 함수는 아래와 같다:

```rust
fn print_it(arg: dyn &Fn() -> String);
print_it(&hello_world);
```

아무것도 반환하지 않는 함수도 사실은 아무것도 아닌 무언가를 반환하고 있다.
아래의 셋은 동일하다:

```rust
fn main() { /* ... */ }
fn main() -> () { /* ... */ }
fn main() { return (); } // () 타입은 그 값도 ()로 표기한다.
```

C계열 언어에서는 반환값이 없는 함수를 표현할 때에 `void`로 선언하기 때문에
좀 더 명시적으로 확인할 수 있다.

```c
void function_no_return() { /* ... */ }
```

단위 타입을 이용함으로써 아무것도 아님을 표현할 수 있다.

어떤 타입 `T`를 받아 단위 타입을 반환하는 함수는 타입 별로 딱 하나만 존재한다.
예를 들어 `bool -> ()`인 함수는 아래의 함수 외에는 존재할 수 없다.

```rust
fn unit(_: bool) -> () { return (); }
```

반대로 단위 타입을 받아 어떤 타입 `T`를 반환하려면, 타입 `T`의 원소 수만큼
함수를 만들 수 있다. 예를 들어 `() -> bool`인 함수는 아래의 두 함수가 있다.

```rust
fn true() -> bool { true }
fn false() -> bool { false }
```

### 원소가 둘인 집합

원소가 둘인 집합은 그 값이 이거 아니면 저거인 집합이다.

```rust
enum Boolean {
    True,
    False,
}
```

우리에게 친숙한 원소가 둘인 집합은 바로 `bool`이다. `0`, `1`도 좋고
`true`, `false`도 좋다. 어쨌든 원소는 둘뿐이어야한다.

$$
\text{bool} = \{\text{true}, \text{false}\}
$$

`bool`을 취하여 `bool`을 반환하는 함수는 몇 개나 있을까? 집합 $F$의 갯수를
생각해보자.

$$
F = \{ f \mid f : \text{bool} \rightarrow \text{bool} \}
$$

아래와 같이 항등함수 두 개(`always`, `never`), 단위함수 하나(`id`), `not` 함수까지
총 네 개를 생각할 수 있다.

```rust
fn always(_: bool) -> { true }
fn never(_: bool) -> { false }
fn id(b: bool) -> { b }
fn not(b: bool) -> {
    match b {
        true -> false,
        false -> true,
    }
}
```

우리가 흔히 쓰는 "boolean 타입"과 완벽히 대응함을 알 수 있다.

### 합집합

두 집합 A, B가 있을 때, 두 집합의 모든 원소를 가지고 새로운 집합을 만들
수 있다. 새로운 집합 $A \cup B$의 원소는 본래 $A$의 원소이거나 $B$의 원소이다.
이를 합집합(_union_)이라 부르고 아래처럼 정의한다:

$$
A \cup B = \{ x \mid x \in A \lor x \in B \}
$$

합집합에 대응하는 타입은 합타입(_union type_ 혹은 _sum type_)이다.
합타입을 이용하면 타입을 확장할 수 있다.
아래의 예시에서 `Number`의 원소는 `i64`의 원소이거나 `f64`의 원소이다:

```rust
enum Number {
    Int(i64),
    Float(f64),
}
let a: Number = Int(3);
let b: Number = Float(1.1);
```

어떤 언어는 다음처럼 쉽게 합집합을 표현할 수 있도록 한다.

```typescript
function padLeft(value: string, padding: string | number);
```

위의 `enum`으로 표현한 합타입과 밑의 `|`로 표현한 합타입은 무슨 차이가 있을까?
같은 타입을 합쳤을 경우를 살펴보자:

```typescript
let bnb = boolean | boolean;
```

`|`로 같은 타입을 합집합을 만들 경우 본래의 타입과 다를 바가 없다. 같은 집합의
원소를 모으면 본래의 집합과 동일하다.

$$
\begin{aligned}
\text{BnB} &= \{ x \mid x \in \text{boolean} \lor x \in \text{boolean} \}\\
&= \{ x \mid x \in \text{boolean} \}\\
&= \{\text{true}, \text{false}\}
\end{aligned}
$$

```rust
enum BnB {
    B1(bool),
    B2(bool),
}
```

타입 생성자(위의 `B1`, `B2`)와 함께 정의한 경우 그냥 합집합이 아니라 서로소
합집합(_disjoint union_)이 된다. `B1`으로 정의하는 `bool`과 `B2`로 정의하는
`bool`은 서로 다른 타입이다. 값도 동일하지 않다. `B1(true)`과 `B2(true)`는
다른 값이다. 따라서 타입 `BnB`의 가능한 값은 총 네 가지이다.

$$
\begin{aligned}
\text{BnB}
 &= \{x \mid x \in \text{bool}_1 \lor x \in \text{bool}_2 \}\\
 &= \{\text{true}_1, \text{false}_1, \text{true}_2, \text{false}_2\}
\end{aligned}
$$

### 교집합

합집합이 있으므로 교집합도 있지 않을까?
$A \cap B$는 $A$의 원소이면서 동시에 $B$의 원소인 값들의 집합이다.

$$
A \cap B = \{x \mid x \in A \land x \in B\}
$$

### 곱집합

집합을 합할 수 있으므로 곱할수도 있다. 곱집합(_product set_)은 두 집합의 원소로
만들 수 있는 가능한 모든 쌍의 집합으로 정의한다.

$$
A \times B = \{(a, b) \mid a \in A \land b \in B \}
$$

곱타입은 구조체(_struct_) 혹은 튜플로 정의할 수 있다. 이를 이용하면
타입을 조합할 수 있다.