---
title: 데이터베이스
description: 데이터베이스
date: 2023-02-24
tags: [computer-science]
---

- [[transaction]]

## 여러가지 키

키는 속성 혹은 속성의 집합이 될 수 있다.

어떤 키를 이용하여 각각의 튜플을 특정해낼 수 있다면 그 키는 **유일성**을
만족한다.

- 수퍼키(super key): 유일성을 만족하는 키
- 후보키(candidate key): 최소한의 구성으로 유일성을 만족하는 키
- 기본키(primary key): 후보키 중 기본으로 사용하고자 선택한 키
- 대체키(alternative key): 기본키가 아닌 후보키
- 외래키(foreign key): 다른 릴레이션을 참고할 때 사용하는 키

## 무결성과 제약조건

데이터베이스는 데이터의 무결성을 보장해야한다. 이를 위해 여러 제약조건을 걸고
지킨다.

자료마다 선정하는 무결성이 다른데 대체로 개체 무결성, 참조 무결성, 도메인
무결성은 무조건 고려하는 듯.

- 개체 무결성: 개체가 존재하면 기본키로 구분할 수 있어야 한다.
- 참조 무결성: 외래키는 유효한 PK이거나 NULL이어야한다.
- 속성 무결성: 속성의 값이 타입과 맞아야 한다.
- 키 무결성: 키는 반드시 하나의 튜플만을 가리켜야 한다.
- 도메인 무결성: 해당 업무 도메인의 시선으로 보았을 때 올바라야 한다.

**참조 무결성**을 지키기 위하여 아래와 같은 제약조건을 걸 수 있다:

- restrict(제한): 삭제할 수 없도록 한다.
- cascade(다단계): 부모가 삭제되면 자식도 삭제한다.
- nullify(널化): 부모가 삭제되면 자식의 참조값을 null로 바꾼다.
- default(기본값): 부모가 삭제되면 미리 지정한 기본값으로 바꾼다.

### 예시

elixir의 ORM인 [Ecto](https://hexdocs.pm/ecto/Ecto.html)에서는 테이블 스키마를
서술할 때, `references`로 외래키를 명시하는데 이 때 참조 무결성에 대한 옵션을
줄 수 있다.

```elixir
def up do
  create table("weather", prefix: "north_america") do
    add :city,    :string, size: 40
    add :temp_lo, :integer
    add :temp_hi, :integer
    add :prcp,    :float
    add :group_id, references(:groups, on_delete: :delete_all)
    #                                              ^
    #                               :nilify_all, :restrict, :delete_all과 같은
    #                               옵션을 쓸 수 있다.

    timestamps()
  end

  create index("weather", [:city], prefix: "north_america")
end
```

## 참고

- 한양미, [데이터베이스의 원리와 응용](http://www.kocw.net/home/search/kemView.do?kemId=1163794). 한양대학교, 2015.
