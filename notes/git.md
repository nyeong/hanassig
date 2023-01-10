---
title: git
tags: []
---

## 치트시트

### 파일 복구하기

파일을 삭제하고 커밋 후 복구하기

```bash
# 먼저 파일이 살아있는 커밋을 찾는다.
git log -- filename
git log -p -- filename
git show -- filename

# 커밋에서 파일을 가져온다
git checkout commit -- filename
```