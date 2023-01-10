---
title: PostgreSQL
tags: []
---

[PostgreSQL: The world's most advanced open source database](https://www.postgresql.org/)

PostgreSQL 설치와 기본 사용법 정리.

- [[ROLE 관리하기]]

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

## 참고

- Stephan Schmidt, [Just Use Postgres for Everything](https://www.amazingcto.com/postgres-for-everything/).
- [PostgreSQL 13.3 문서](https://www.postgresql.kr/docs/13/) – 자습서 최신 번역본