---
title: N+1 문제
date: 2023-06-09
---

원하는 정보를 얻기 위해 주 쿼리로 N개의 컬럼을 가져왔는데, N개 컬럼을 위해
N개의 서브 쿼리가 실행해야 하는 현상을 N+1 문제라고 한다.

## 예시

집사와 고양이가 1:N 관계라고 하자. 하나의 집사는 고양이 여럿을 기르고 있다.

집사-고양이 테이블은 아래와 같다:

| id | 이름|
|----|----|
| 1  | a  |
| 2  | b  |
| 3  | c  |

고양이 테이블은 아래와 같다:

| id| 이름       | 집사id|
|---|-----------|------|
| 1 | nabi      |  1   |
| 2 | neko      |  1   |
| 3 | nabineko  |  2   |


이때 각 집사가 기르고 있는 고양이들의 이름을 가져오고 싶다면 아래와 같이
해야한다:

1. 집사 테이블에서 집사 목록을 가져온다.
2. 각 집사 id를 이용하여 고양이 테이블에서 해당 집사의 고양이를 찾는다.

이때 2번 쿼리를 N번 해야하므로 결국 N+1번 쿼리를 하게 된다. SQL로 표현하면
아래와 같다:

```sql
SELECT * FROM butlers;
SELECT * FROM cats WHERE cats.butler_id = 1;
SELECT * FROM cats WHERE cats.butler_id = 2;
SELECT * FROM cats WHERE cats.butler_id = 3;
...
```

## 뭔 소리야

이 문제를 처음 들었을 때 그냥 join 걸면 되는 거 아닌가...? 싶었다.
그러나 아래와 같은 경우에는 단순히 해결 가능한 문제가 아니었다.

1. ORM을 이용하고 있을 때
2. 각각 다른 곳에서 자료를 가져와야 할 경우
3. 클라이언트에서 API를 호출할 때

## ORM을 이용하고 있을 때

ORM으로 추상화 된 경우에는 이런 문제가 제대로 보이지 않을 수 있다. 따라서
아래와 같은 실수를 하기 쉽다.

Elixir에서 ORM으로 주로 채택하는 Ecto를 예로 들어보자. 다른 라이브러리도 비슷할
것이다. 먼저 `Ecto.Schema`를 이용하여 스키마를 정의한다. 이 둘이 1:N 관계임은
`has_many`와 `belongs_to` 필드를 이용하여 정의한다.

```elixir
defmodule Np1p.Entity.Butler do
  use Ecto.Schema
  schema "butlers" do
    field :name, :string
    has_many :cats, Np1p.Entity.Cat
  end
end

defmodule Np1p.Entity.Cat do
  use Ecto.Schema
  schema "cats" do
    field :name, :string
    belongs_to :butler, Np1p.Entity.Butler
  end
end
```

이제 DB에 저장된 내용을 가져오자. `Repo.all`에 스키마를 넣으면 가져올 수 있다.

```iex
iex> alias Entity.{Cat, Butler}
iex> alias Np1p.Repo
iex> Repo.all(Butler)
[debug] QUERY OK source="butlers" db=0.2ms queue=0.2ms idle=1316.4ms
SELECT b0."id", b0."name", b0."inserted_at", b0."updated_at" FROM "butlers" AS b0 []
[
  %Np1p.Entity.Butler{
    __meta__: #Ecto.Schema.Metadata<:loaded, "butlers">,
    id: 1,
    name: "a",
    cats: #Ecto.Association.NotLoaded<association :cats is not loaded>,
  },
  # 생략 ...
]
```

`Butler`의 자료형을 보면 `cats` 필드가 `NotLoaded`로 비어있다. 어떤 집사가
어떤 고양이를 키우고 있는지 알고싶으니 이 빈칸을 채워보자.

```iex
iex> import Ecto.Query
iex> Repo.all(Butler)
|> Enum.map(fn butler ->
  cats = Repo.all(from cat in Cat, where: cat.id == ^butler.id)
  %{&1 | cats: cats}
)
[debug] QUERY OK source="butlers" db=0.8ms idle=1381.0ms
SELECT b0."id", b0."name", b0."inserted_at", b0."updated_at" FROM "butlers" AS b0 []
[debug] QUERY OK source="cats" db=0.2ms queue=0.3ms idle=1391.2ms
SELECT c0."id", c0."name", c0."butler_id", c0."inserted_at", c0."updated_at"
  FROM "cats" AS c0 WHERE (c0."butler_id" = ?) [1]
[debug] QUERY OK source="cats" db=0.2ms idle=1392.0ms
SELECT c0."id", c0."name", c0."butler_id", c0."inserted_at", c0."updated_at"
  FROM "cats" AS c0 WHERE (c0."butler_id" = ?) [2]
[debug] QUERY OK source="cats" db=0.2ms idle=1392.4ms
SELECT c0."id", c0."name", c0."butler_id", c0."inserted_at", c0."updated_at"
  FROM "cats" AS c0 WHERE (c0."butler_id" = ?) [3]
[
  %Np1p.Entity.Butler{
    __meta__: #Ecto.Schema.Metadata<:loaded, "butlers">,
    id: 1,
    name: "a",
    cats: [
      %Np1p.Entity.Cat{
        __meta__: #Ecto.Schema.Metadata<:loaded, "cats">,
        id: 1,
        name: "nabi",
        butler_id: 1,
      },
# 생략 ...
```

아무 생각 없이 쿼리의 결과에 다시 쿼리를 걸면 우려했던대로 N+1번의 쿼리 호출이
일어난다. 로그를 보면 총 네 번의 SELECT 호출이 이뤄졌음을 알 수 있다.

### 두 번 쿼리하여 해결하기

잘 생각해보면 두 번만에 해결 가능하다. 첫번째 쿼리에서, 그 다음에 필요한 정보를
이미 모두 가져왔기 때문에 한 번의 추가 쿼리로 나머지를 모두 가져오면 된다.

Ecto 라이브러리에서는 이를 `preload` 매크로로 간편하게 가능하다.

```iex
iex> Repo.all(Butler) |> Repo.preload(:cats)
[debug] QUERY OK source="butlers" db=0.9ms queue=0.1ms idle=1345.0ms
SELECT b0."id", b0."name", b0."inserted_at", b0."updated_at" FROM "butlers" AS b0 []
[debug] QUERY OK source="cats" db=0.9ms idle=1348.5ms
SELECT c0."id", c0."name", c0."butler_id", c0."inserted_at", c0."updated_at",
  c0."butler_id" FROM "cats" AS c0 WHERE (c0."butler_id" IN (?,?,?))
  ORDER BY c0."butler_id" [3, 2, 1]
# 생략 ...
```

쿼리를 보면 두 번의 SELECT로 내용을 모두 가져왔음을 알 수 있다. 반환값은 위의
Enum을 활용한 것과 동일하다.

### join 써서 해결하기

앞서 말한대로 join을 써서 쿼리하면 두 번 할 필요가 없다. 다만 쿼리로 계층
구조를 나타내기는 어려우므로 활용하고자 하는 자료를 잘 확인하고 쿼리문을
작성해야겠다.

```iex
iex> q = Butler \
...> |> join(:inner, [b], c in Cat, on: b.id == c.butler_id) \
...> |> select([b, c], {b.name, c.name})
iex> Repo.all(from b in Butler)
[debug] QUERY OK source="butlers" db=0.2ms queue=0.3ms idle=1376.3ms
SELECT b0."name", c1."name" FROM "butlers" AS b0 INNER JOIN "cats" AS c1 ON
  b0."id" = c1."butler_id" []
[{"a", "nabi"}, {"a", "neko"}, {"c", "nabineko"}]
```
