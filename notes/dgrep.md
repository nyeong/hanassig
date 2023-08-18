---
title: dgrep
description: 동시적 grep 구현하기
---

grep을 구현하여 동시성을 공부해보자.

```
$ dgrep {keyword} {relative path[, ...]}
```

## 목표

동시성에 대해 공부하는 것이 목표이다. 정규식이나 문자 탐색 알고리즘 등에 대해
신경쓰고 싶지 않다.

## 성능 측정

구현이 효율적인지 알아보려면 측정할 지표가 필요하다. 아래의 세 개의 지표면
충분하지 않을까?

1. 속도가 얼마나 빠른지
2. 메모리를 얼마나 쓰는지
3. CPU를 얼마나 쓰는지

[cmdbench](https://github.com/manzik/cmdbench)라는 파이썬 유틸리티가 CPU 시간,
메모리 사용량 등을 체크해준다. 이걸 이용하자.

측정할 지표는 정했는데, 무슨 자료로 지표를 측정할까? 크게 두 가지 경우가 바로
떠오른다:

1. 파일이 엄청 많을 때
2. 파일이 엄청 클 때
3. 파일이 별로 안 클 때

## 동시성 없이


## 참고

- [데브시스터즈 서버 직군은 왜 코딩 면접을 볼까?](https://tech.devsisters.com/posts/server-position-coding-test/)
- [[concurrency]]
