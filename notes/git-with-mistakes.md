---
title: git에서 실수했을 때
date: 2023-05-03
tags:
  - git
---

## 실수 찾기

- `git status`
- `git log`
- `git reflog`
- `git diff`
- `git blame`
- `git bisect`

## 커밋을 되돌리기

- `git reset`: 이전의 커밋으로 되돌아간다.
  - `--hard`: 되돌아가는 커밋 이후의 모든 변경을 삭제하여 없던 일로 만든다.
  - `--soft`: 커밋은 삭제하되, 변경 내용을 스테이지에 유지한다.
  - `--mixed`:  커밋은 삭제하고 변경 내용을 유지하되, 스테이징 하지 않는다.
- `git revert`: 이전 커밋으로 되돌리는 새로운 커밋을 만든다.
  - 지금까지의 커밋을 변경하지 않고 새로운 커밋을 만들기 때문에, 변경 내용이
	  보존된다.
  - `--no-commit`: 이전 커밋의 상태로 되돌리되, 새로운 커밋을 만들지 않는다.
    여러 커밋을 한 번에 되돌릴 때 유용하다.

`git reset`은 이전 커밋 내역을 삭제하므로, 원격 저장소에 이미 올라간 커밋을
수정하기에는 부적합하다. 이 경우에는 `git revert`를 이용하여 히스토리를
유지해주어야 효율적으로 협업할 수 있다.

```bash
# A커밋부터 HEAD커밋까지의 작업을 취소하되, 커밋 히스토리는 남기고
# 변경 사항을 작업공간에 두기
$ git revert --no-commit A..HEAD

# 한 번에 커밋
$ git commit -m 'revert A..HEAD'
```

## 특정 파일만 되돌리기

- `git checkout filename`: 로컬파일의 수정사항을 취소하기. 마지막 커밋의
	상태로 바꾼다.
- `git checkout commit filename`: 해당 파일을 특정 커밋의 상태로 바꾼다.

## 커밋의 범위 표현하기

- `HEAD@{n}`: HEAD가 가리키고 있던 커밋. `git reflog`로 조회할 수 있다.
- `branch@{yesterday}`: 브랜치 `branch`에 어제 있던건 커밋.
- `HEAD^`: 캐럿(`^`)을 붙이면 해당 커밋의 부모 커밋. `git log --graph`로 부모를
  시각적으로 추적할 수 있다.
  - `9e53^2`이면 커밋 `9e53`의 두번째 부모. 부모가 둘 이상이여야 유효.
- `A..B`: 커밋 A부터 커밋 B까지의 범위이나, 커밋 A는 포함하지 아니함
- `A...B`: 위와 동일하나 커밋 A도 포함함
- `HEAD~n`: HEAD 커밋의 부모의 부모의 부모의... 부모 커밋

## 참고

- [Git - 리비전 조회하기](https://git-scm.com/book/ko/v2/Git-%EB%8F%84%EA%B5%AC-%EB%A6%AC%EB%B9%84%EC%A0%84-%EC%A1%B0%ED%9A%8C%ED%95%98%EA%B8%B0)
