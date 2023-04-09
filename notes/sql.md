---
title: SQL
description: SQL 기초 사용법
date: 2023-03-09
tags:
---

## SELECT

### LIKE

https://www.postgresql.org/docs/current/functions-matching.html

```sql
SELECT FACTORY_ID, FACTORY_NAME, ADDRESS
FROM FOOD_FACTORY
WHERE ADDRESS LIKE "강원도%"
...;
```

### COALESCE

https://www.postgresql.org/docs/current/functions-conditional.html#FUNCTIONS-COALESCE-NVL-IFNULL

NULL인 경우 출력을 대체할 수 있음

```SQL
-- TLNO가 NULL인 경우 NONE을 출력
SELECT COALESCE(TLNO, "NONE") FROM PATIENT ...
```
