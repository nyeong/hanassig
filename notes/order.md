---
title: 순서
description: 전순서와 부분순서
date: 2023-03-17
tags:
---

직관적으로 생각하는 순서는 정수의 크기비교이다.

$$
\cdots \le 2 \le -1 \le 0 \le 1 \le 2 \le \cdots
$$

순서라는 개념을, 두 원소가 특정 조건을 만족하는 관계로 일반화하여 생각할 수 있다.
조건에 따라 준순서, 부분순서, 전순서 등으로 확장하여 생각할 수 있다.

순서를 표기할 때 $\le$ 기호를 그대로 쓰기도 하고, $\prec$ 기호처럼 살짝 다른 부등호를 써서 정의하기도 한다. 보통 부분순서에 $\prec$, 전순서에 $\preceq$ 쓰는 듯.

## 준순서

어떤 집합 $S$에 대해 이항 관계 $\le$가 준순서(*preorder*)이려면, $\forall a, b, c \in S$에 대하여 아래를 만족해야한다.

- $a \le a$: 반사적
- $a \le b \land b \le c \rightarrow a \le c$: 추이적

## 전순서

어떤 집합 $S$에 대해 이항 관계 $\le$가 전순서(*total order*)이려면, $\forall a, b, c \in S$에 대하여 아래를 만족해야한다.

- $a \le a$: 반사적
- $a \le b \lor b \le a$: 연결적
- $a \le b \land b \le a \rightarrow a = b$: 반대칭적
- $a \le b \land b \le c \rightarrow a \le c$: 추이적

전순서 관계인 집합의 원소는 그 크기를 비교하여 일렬로 늘여 놓을 수 있다. 이 때문에 선형 순서(*linear order*)라고 부르기도 한다.

### 예시

- 실수
- 사전식 순서
- 시간

## 부분순서

부분순서(*partial order*)는 전순서에서 **어떤 원소든 비교할 수 있다**는 성질이 빠진다.

- $a \le a$: 반사적
- $a \le b \land b \le a \rightarrow a = b$: 반대칭적
- $a \le b \land b \le c \rightarrow a \le c$: 추이적

### 예시

집합 $\{x, y, z\}$의 부분집합들의 포함관계는 부분순서이다.

- 모든 원소는 스스로의 부분집합이므로 반사적이다.
- $a \subseteq b \land b \subseteq a$인 관계는 $a = b$일 때 뿐이므로, 반대칭적이다.
- $\emptyset \subseteq \{x\} \subseteq \{x, y\} \subseteq \{x,y,z\}$인 것 처럼, 추이성도 성립한다.
- $\{ y \} \not\subseteq \{x, z\}$인 것처럼, 모든 관계에서 순서가 성립하는 것이 아니므로 전순서는 아니다.

아래 그림은 위의 예에 대한 하세 다이어그램이다.

![](/assets/hasse_diagram_of_powerset.png)

## 관계의 성질

아래의 정의는 $\forall a, b \land S \neq \emptyset$에 대해서이다.

- $R=\{(a, b) \in A \times A \mid  a | b\}$
- $a|b$는 $(a, b) \in R$과 동일하다.

### 반사적 관계

모든 원소에 대해 스스로와의 관계가 성립한다면 반사적(*reflexive*)이다.

$$
a|a
$$

- 정수에서 모든 수는 자기 자신과 같고($=$), 같거나 작고($\le$), 같거나 크다($\ge$).
- 집합에서 모든 집합은 자기 자신을 부분집합($\subset$)으로 삼는다.

정수의 $\ne$, $\gt$, $\lt$는 반사적이지 않다. 이를 비반사적(*irreflexive*)이라고 한다.

### 대칭 관계와 반대칭 관계

$a|b$가 성립할 때 그 대칭적 관계, 즉 $b|a$도 성립하면 대칭적(*symmetric*)이다.

$$
a|b \Rightarrow b|a
$$

두 항이 같을 때에만 대칭 관계가 성립하면 반대칭적(*antisymmetric*)이다.

$$
a|b \land b|a \Rightarrow a = b
$$

아예 대칭 관계가 성립하지 않으면 비대칭적(*asymmetric*)이다.

$$
a|b \Rightarrow \lnot (b|a)
$$

### 추이적 관계

두 관계로 새로운 관계를 유추할 수 있다면 추이적(*transitive*)이라고 한다.

$$
a|b \lor b|c \Rightarrow a|c
$$


- 정수 a, b, c가 있을 때, $a < b$이고 $b < c$이면 $a < c$이다.
	- $\forall a, b, c \in \mathbb{R}, a < b \land b < c \Rightarrow a < c$
- 집합 $A, B, C$에 대하여, $A \subseteq B \land B \subseteq C \Rightarrow A \subseteq C$

### 연결성?

종류가 여럿 있는데 용어 통일이 안 된 모양새이다.
집합의 전체 원소에 대해 관계를 만족하는 것을 연결되어있다고 한다.

- 연결되어있다(*connected*) : $a \neq b \Rightarrow (a|b \lor b|a)$
- 혹은 $a|b \lor b|a \lor a = b$
- 강하게 연결되어있다: $a|b \lor b|a$

## 참고

- [Total order - Wikipedia](https://en.wikipedia.org/wiki/Total_order)
- Bartosz Milewski, Category Theory for Programmers.
- [관계(Relations) - 기계인간 John Grib](https://johngrib.github.io/wiki/relations/#%EB%8C%80%EC%B9%AD-%EB%B0%98%EB%8C%80%EC%B9%AD-%EA%B4%80%EA%B3%84).
- 황병연, [이산수학](http://www.kocw.net/home/cview.do?lid=89d3066f26b87171).
