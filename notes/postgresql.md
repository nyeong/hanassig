---
title: PostgreSQL
description: PostgreSQL 기본적인 사용법 정리
date: 2023-03-04
tags:
---

[PostgreSQL: The world's most advanced open source database](https://www.postgresql.org/)

## 설치

세 가지 선택지가 있다:

- 직접 빌드한다
- 컨테이너로 깐다
- 패키지 매니저로 깐다

### macOS

brew로 깔고 brew services로 돌린다. 버전명이 붙은 formula이기 때문에 아래처럼 PATH를 등록해주어야 `psql`이나 `createdb`와 같은 명령어를 쓸 수 있다.

```
brew install postgresql@15
echo 'export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"' >> ~/.zshrc
brew services start postgresql@15
```

## 시작하기

PostgreSQL은 클라이언트/서버 모델 데이터베이스이다. 클라이언트는 PostgreSQL에서
제공하는 프론트엔드가 될 수도 있고, 사용자가 개발하는 어플리케이션이 될 수도
있다.

PostgreSQL 서버 프로세스는 새 클라이언트가 접속할 때마다 프로세스를 포크한다.

<figure>
  <video src="/assets/postgresql-forks.webm" />
  <figcaption>클라이언트가 열고 닫힘에 따라 켜지고 꺼지는 fork 프로세스</figcaption>
</figure>

PostgreSQL 서버는 여러 데이터베이스를 관리할 수 있다.

- `createdb [DB 이름]` -- DB 생성
- `dropdb [DB 이름]` -- DB 삭제
- `psql [DB 이름]` -- DB 접속

### psql

SQL이 아닌 명령어는 `\`으로 시작한다.

- `\h` -- 도움말.
- `\i` -- 파일에서 SQL 읽어오기.
- `\d` -- 현재 DB의 모든 객체 나열.
- `\d [테이블 이름]` -- 테이블의 구조 확인. `\d+`는 더 자세한 정보가 나온다.
- `\d [함수 이름]` -- 함수의 인자, 반환형 등 확인.
- `\dt` -- 현재 DB의 모든 테이블 나열.
- `\dt [테이블 이름]` -- 테이블과 관련된 테이블 나열.

## SQL

<figure>
  <img src="/assets/table-row-column.png" />
  <figcaption>table, column, row</figcaption>
</figure>

### 테이블 만들고 지우기

```sql
CREATE TABLE cities (
  name       varchar(80),
  location   point  
);

DROP TABLE cities;
```

표준 SQL 타입: `int`, `smallint`, `real`, `double precision`, `char(n)`,
`varchar(n)`, `date`, `time`, `interval`, ...

`point` 같은 비표준 타입도 있으며, 타입을 새로 만들 수도 있음[^1].

[^1]: https://www.postgresql.org/docs/current/sql-createtype.html

그 외의 자료형은 [문서 참고](https://www.postgresql.org/docs/current/datatype.html)

TODO: 테이블 이름은 복수형이여야 하는가?
https://stackoverflow.com/questions/4702728/relational-table-naming-convention

### 행 삽입하기

- column 순서에 맞게 기입해야함.
  - 혹은 column 순서를 명시할 수 있음.
- column은 nullable하다면 생략할 수 있음.
- 숫자가 아닌 값은 작은따옴표(`'`)로 감싸야함.

```sql
INSERT INTO cities VALUES ('Seoul', '(37.5642, 127.0016)');

INSERT INTO cities (name, location)
  VALUES ('Seoul', '(37.5642, 127.0016)');
```

### 쿼리하기

`SELECT`로 테이블에서 값을 얻어올 수 있음. `*`로 모든 컬럼을 얻어올 수도 있다:

```sql
SELECT name FROM cities;

SELECT * FROM cities;
```

가져온 필드로 연산을 할 수도 있다:

```sql
SELECT city, (temp_hi + temp_lo) / 2 AS temp_avg, FROM weather;
```

`WHERE`로 가져올 테이블의 조건을 명시하거나, 가져온 데이터를 정렬할 수 있다:

```sql
SELECT * FROM weather
  WHERE city = 'Seoul'
  ORDER BY city;
```

중복된 행은 빼고 가져올 수 있다:

```sql
SELECT DISTINCT city FROM weather;
```

### 조인

여러 테이블의 정보를 연관지어 하나의 결과를 만드는 것을 조인이라고 한다.

- inner join: 두 테이블에서 특정 값이 일치하는 데이터만 찾는다.
- outer join: 일치하지 않는 데이터도 가져온다.
  - left outer join: 왼쪽 테이블에 오른쪽 테이블을 결합한다.
  - rigjt outer join: 왼쪽 테이블을 오른쪽 테이블에 결합한다.
  - full outer join: 두 테이블에서 모든 데이터를 가져온다.
- cross join

#### inner join

```sql
CREATE TABLE weather (
	city		varchar(80),
	temp_lo		int,		-- low temperature
	temp_hi		int,		-- high temperature
	prcp		real,		-- precipitation
	date		date
);

CREATE TABLE cities (
	name		varchar(80),
	location	point
);

-- join on
SELECT * FROM weather JOIN cities ON city = name;

SELECT weather.city, weather.temp_lo FROM weather
  JOIN cities ON weather.city = cities.name;

- join 키워드 없이 조인
SELECT * FROM weather, cities WHERE city = name;
```

`weather` 테이블과 `cities` 테이블이 있다. `weather` 테이블의 정보 중 `city`
컬럼을 `cities`의 `name`과 연관지어 `cities`의 내용도 쿼리하였다.

위의 예에서는 두 테이블에 겹치는 컬럼이 없지만, 있을 경우 테이블 이름을
접두어로 쓸 수 있다.

left join과 right join은 기준만 다르고 동작은 같다. 하나의 테이블은 온전히
출력하되, 참고하는 테이블에 값이 일치하는 행이 있다면 그 내용을 가져온다.

```sql
-- 아래의 두 SELECT의 결과는 column의 순서만 다르고 내용은 같다:

SELECT * FROM weather
  LEFT OUTER JOIN cities ON weather.city = cities.name;

SELECT * FROM cities
  RIGHT OUTER JOIN weather ON weather.city = cities.name;
```

## 참고

- Stephan Schmidt, [Just Use Postgres for Everything](https://www.amazingcto.com/postgres-for-everything/).
- [PostgreSQL 13.3 문서](https://www.postgresql.kr/docs/13/) – 자습서 최신 번역본
- [PostgreSQL Documentation](https://www.postgresql.org/docs/current/tutorial-arch.html)