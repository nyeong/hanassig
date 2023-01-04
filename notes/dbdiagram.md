---
title: dbdiagram
tags: []
---

[dbdiagram.io](https://dbdiagram.io/home) 테이블 관계를 도식화 할 수 있는 도구.

## 테이블 선언

```dbdiagram
Table tablename {
  field1 type [attributes]
}
```

### 속성

- `pk` – primary key
- `unique`
- `not null`
- `default: 'now()'
- `note: 'description'` 말 그대로 노트

## 인덱스 선언

```
Indexes {
  (field1, field2) [attribute]
}
```

## 관계 설정하기

```
// 1:다 관계
Ref: table1.field > table2.field

// 다:다 관계
Ref: table1.field <> table2.field

Table table1 {
  table2_id table2 [ref: < table2.id]
}
```