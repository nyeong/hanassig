---
title: ROLE 관리하기
tags: [PostgreSQL]
---

> 수퍼유저는 아니지만 `CREATEDB` 및 `CREATEROLE` 권한이 있는 role을 생성하고, 데이터베이스와 role의 모든 루틴 관리에 대해 이 role을 사용하는 것이 좋다. 이러한 방법으로 실제로 수퍼유저 권한이 불필요한 작업을 수퍼유저로 실행하는 위험이 방지된다.

```sql
CREATE ROLE name LOGIN CREATEDB CREATEROLE PASSWORLD 'password';
```

## USER와 ROLE의 차이

- TODO: LOGIN 권한이 없는 ROLE은 왜 있는 걸까?
- LOGIN 권한이 있는 ROLE이 USER.
- `CREATE USER name`는 `CREATE ROLE name LOGIN`과 같다.

## 참고

- [PostgreSQL: Documentation: 15: 22.2. Role Attributes](https://www.postgresql.org/docs/current/role-attributes.html)