---
title: idris
description: idris 프로그래밍 언어
date: 2023-03-15
tags:
---

## 어떤 언어인가

- 타입 주도 개발(type driven development)을 위해 개발됨
- 타입이 1급 구조(_first-class constructs_)임
  - 문자열, 정수 등의 값처럼 타입을 다룰 수 있음
  - 함수에 인자로서 전달될 수 있음
  - 함수가 반환할 수 있음

## 기본 도구와 생태계

- `idris` — 컴파일러이자 REPL이자 타입 분석 도구

### REPL에서

[The Idris REPL — Idris 1.3.3 documentation](https://docs.idris-lang.org/en/latest/reference/repl.html)

- `:module <module name>` — 모듈 불러오기
- `:l <file name>` — 파일 불러오기
- `:t <expr>` — 타입 확인하기
- `:r` — 다시 불러오기
- `:t` — 값 바인딩하기

## 기본 자료구조

- 수: `Int`, `Integer`, `Double`
- 문자: `Char`, `String`
- 포인터: `Ptr`
- 부울: `Bool`, `True`, `False`
- 타입: `Type`

표현문의 끝은 들여쓰기로 구분한다. 값의 타입 지정과 선언은 아래와 같이 한다.
하스켈과 다르게 타입 지정을 `:`로 하고, 리스트 연결을 `::`로 한다.

```idris
x : Int
x = 3
```

idris로 작성한 자연수 타입 `Nat`와 리스트 타입 `List`의 선언은 아래와 같다:

```idris
data Nat = Z | S Nat
data List a = Nil | (::) a (List a)
```

## 의존 타입

보통의 언어들은 타입 선언에서는 타입만 다룰 수 있고, 함수의 몸체에서는 값만 다룰 수 있다. idris의 타입은 1급 시민으로, 값과 차이 없이 다룰 수 있다. 인자로도 받을 수 있고, 함수가 반환도 할 수 있다. 아래의 예시에서 대문자로 시작하는 것들은 모두 타입이다.

```idris
isSingleton : Bool -> Type
isSingleton True = Nat
isSingleton False = List Nat
```

이렇게 정의한 함수를 다시 타입 선언에 활용할 수도 있다.
아래의 예시에서는 위에서 정의한 `isSingle` 함수를 이용하여 경우에 따라 다른 타입을 반환한다.

```
mkSingle : (x : Bool) -> isSingleton x
mkSingle True = 0
mkSingle False = []
```

- 타입 선언은 컴파일 타임에 실행되며, 프로그램의 검증을 위해 쓰인다.
- 함수 몸체는 런타임에 실행되며, 프로그램의 동작을 위해 쓰인다.

이렇게 보는 게 편할 것 같다.
