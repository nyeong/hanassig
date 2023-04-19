---
title: 프로그래밍 언어
---

- [[elixir]]
- [[idris]]
- [[scala]]
- [[python]]

## 알아야 하는 것들

- 기본 도구와 생태계
  - 버전 관리자
  - 의존성 (VM 혹은 라이브러리)
  - IDE, LSP, REPL
- 타이핑 모델
  - 강타입인가 약타입인가?
  - 동적인가 정적인가?
  - 명목적(*nominal*)인가 구조적(*structural*)인가?
- 프로그래밍 패러다임
  - 함수형, 객체지향, 스택 기반, 배열 기반 등등등
  - 혹은 이 언어만의 특별한 점
- 수를 다루는 방법
  - 산술연산
  - 논리연산
- 자료구조
  - 리스트 등 내장 컨테이너
  - 합타입, 곱타입
- 제어구조
  - 논리제어, 반복제어, 패턴매칭 등
- 문자열을 다루는 방법
- 함수
  - 익명함수, 클로저
- 모듈과 파일 관리
- 문서화
- [[exceptions]]
- 다형성을 달성하는 방법
	- [The Four Polymorphisms in C++](https://github.com/utilForever/modern-cpp-tutorial/blob/master/Articles/The%20Four%20Polymorphisms%20in%20C%2B%2B.md)
	- [다형성이란 무엇인가](https://velog.io/@humonnom/%EB%8B%A4%ED%98%95%EC%84%B1%EC%9D%B4%EB%9E%80-%EB%AC%B4%EC%97%87%EC%9D%B8%EA%B0%80)
	- 파라메트릭 다형성, ad hoc 다형성
	- 트레잇, 제네릭
- [[concurrency]]
- 런타임에서 제공하는 기능들
- 커뮤니티에서 권장하는 것들
  - 스타일 가이드
  - 커뮤니티 라이브러리

## 런타임

C언어의 런타임은 [The C Runtime Initialization](https://www.embecosm.com/appnotes/ean9/html/ch05s02.html) 참고.

러스트는 [최소한의 런타임](https://doc.rust-lang.org/reference/runtime.html)만 구현되어 있으며 필요에 따라 라이브러리 런타임을 사용한다.

- [tokio](https://tokio.rs/) — asynchronous rust runtime
- [actix](https://github.com/actix/actix) — actor framework for rust

[rfcs/0230](https://github.com/rust-lang/rfcs/blob/master/text/0230-remove-runtime.md)을 보면 예전에는 `librustrt`라는 이름의 런타임이 있었으나 현재는 완전 삭제되었다.


## 참고

- 니시오 히로카츠, 코딩을 지탱하는 기술.
- 이광근, 컴퓨터과학이 여는 세계.
- 지민규, [9가지 프로그래밍 언어로 배우는 개념: 1편 - 타입 이론](https://tech.devsisters.com/posts/programming-languages-1-type-theory).
- 탐정토끼, [합성으로 연결되는 함수형과 객체지향](https://twinstae.github.io/composable/).
