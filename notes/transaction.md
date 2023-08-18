---
title: 트랜잭션
description: 트랜잭션이 무엇이고 왜 중요한지 수준 단위로 알아보자
tags: database
---

더이상 쪼갤 수 없는 안되는 업무의 최소 단위를 트랜잭션이라고 부른다.
각각의 트랜잭션은 완전히 성공하거나 완전히 실패해야한다.

현대 컴퓨터 시스템에서는 여러 수준에 걸쳐서 이 개념이 나온다:

- 데이터베이스에서 데이터 유효성을 보장하기 위해
- 응용 프로그램에서 동시성([[concurrency]]) 운용 시 메모리의 유효성을 보장하기 위해 (STM)
- 시스템이 다루는 도메인의 유효성을 보장하기 위해

## 원어에 대해

> 1. The doing or performing of any business; management of any affair; performance.
> 2. That which is done; an affair; as, the transactions on the exchange.
>
> -- Webster's Unabridged 1913

원래는 금융권에서 쓰이는 용어인 것 같다. 거래, 매매를 성사시키는 계약 따위를
트랜잭션이라고 부른다.

## ACID

원자성(atomicity), 정합성(consistency), 고립성(isolation), 영속성(durability)의
머릿글자이다. 트랜잭션이 갖추어야할 속성으로 흔히 꼽는다:

- 원자성: 실행 되거나 말거나 둘 중 하나여야만 한다. one or nothing이라고도 표현한다.
- 정합성: 트랜잭션의 시스템의 정합성을 해쳐서는 안된다.
- 고립성: 각각의 트랜잭션이 고립적이여서 트랜잭션을 수행하는 과정이 다른
          트랜잭션에 영향을 끼쳐선 안된다. 동시에 실행된다 하더라도 각각 실행했을 때와 동일해야한다.
- 영속성: 잘 종료된 트랜잭션은 잘 기록되어 손실되지 않아야 한다.

## 데이터베이스 트랜잭션

데이터베이스 트랜잭션의 핵심은 동시, 그리고 회복이다.[^1] 여러 트랜잭션을 동시에
실행되어도 문제가 없어야하고, 설사 문제가 있다면 회복되어야한다.

대부분의 데이터베이스 시스템에서 별 일 없으면 각각의 SQL 문을 트랜잭션으로 취급한다.

> PostgreSQL은 모든 SQL문을 트랜잭션으로 취급하여 실행한다. BEGIN문 없이 명령을
> 실행한다면, 각각의 구문(statement)는 암묵적으로 BEGIN-COMMIT으로 감싸여 실행된다.
>
> -- [PostgreSQL 15 3.4. Transactions]

> DB에 접근하는 모든 명령어는 트랜잭션이 없다면 자동으로 트랜잭션을 시작한다.
> 자동으로 시작된 트랜잭션은 마지막 SQL 구문이 끝날 때 커밋된다.
>
> -- [SQLite Transaction]

[PostgreSQL 15 3.4. Transactions]: https://www.postgresql.org/docs/current/tutorial-transactions.html
[SQLite Transaction]: https://www.sqlite.org/lang_transaction.html

알아서 트랜잭션이 만들어지는데 왜 트랜잭션을 신경써야할까?

간단하게 RDB에서 송금을 기록하는 상황을 가정해보자. `accounts` 테이블에서
엘리스의 계좌에서 100원을 빼고 밥의 계좌에 100원을 늘릴 것이다.

```sql
UPDATE accounts SET balance = balance + 100 WHERE name = 'bob';
UPDATE accounts SET balance = balance - 100 WHERE name = 'alice';
```

먼저 밥의 계좌에서 100원을 더한다. 그 후 모종의 이유로 밥의 계좌에 100원을
더하지 못했다고 해보자. 

[^1]: 황병연, 데이터베이스 설계

BEGIN-COMMIT과 SAVEPOINT-ROLLBACK TO 연산으로 실현한다.

ORM을 사용한 예시

```elixir
artist = %Artist{name: "Reol"}
Repo.transaction(fn ->
  Repo.insert! artist
end)
```

## 소프트웨어 트랜잭션 메모리

## 도메인 트랜잭션

```elixir
cs =
  %Artist{name: nil}
  |> Ecto.changeset.change()
  |> Ecto.Changeset.validate_required([:name])

Repo.transaction(fn ->
  case Repo.insert(cs) do
    {:ok, result} -> do_something_when_ok()
    {:error, reason} -> do_something_when_error()
  end
  case cs |> from_artist |> Repo.insert do
    {:ok, result} -> do_something_when_ok()
    {:error, reason} -> do_something_when_error()
  end
end)
```

## 분산 환경에서의 트랜잭션

## 참고

- [PostgreSQL 15.4](https://www.postgresql.org/docs/current/index.html)
- [(요약) The Transaction Concept - Virtues and Limitations by Jim Gray, June 1981](https://johngrib.github.io/wiki/summary-the-transaction-concept/)
- [ACID](https://johngrib.github.io/wiki/database/acid/)
- 황병연, [데이터베이스 설계](http://kocw.net/home/cview.do?mty=p&kemId=1207109).
