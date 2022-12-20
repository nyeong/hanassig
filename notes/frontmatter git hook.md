---
title: frontmatter git hook
tags: []
---

frontmatter를 자동으로 추가해주는 git hook을 작성하였다.

현재 이 저장소는 [옵시디언](https://obsidian.md)으로 작성하고 [quartz](https://quartz.jzhao.xyz/)로
퍼블리싱하고 있다.

이 둘 때문에 각 문서(`.md` 파일)이 아래의 형태를 취하고 있다:

1. 파일의 이름을 문서의 제목으로 삼고 있다. (옵시디언 때문에)
2. frontmatter가 있어야 하고 그 안에 `title`이 있어야 한다. (quartz 때문에)

제목이 두 곳에 동시에 들어가야 하는 상황이다. 이름이 없는 파일이 없으니 1번을
까먹는 일은 없는데, 2번을 하는 게 여간 귀찮은 것이 아니다. `---`으로 블록을 만들고 파일 이름으로 적었던 것을
굳이 또 적어야 한다.

귀찮아서 방치하고 있다가 옛날에 git hook에 대해 들은 것이 불현듯 기억나 허겁지겁 짜보았다.

## 고칠 대상 찾기

고쳐야 하는 대상은 크게 세 가지이다.

1. frontmatter 자체가 없거나.
2. frontmatter는 있는데 안에 title이 없거나.
3. 잘못 눌러서 만들어진 빈 문서이거나.

셋 모두 `grep`으로 쉽게 확인할 수 있다.

1번의 경우, `^---$` 정규식으로 검사하여서 통과하지 못하면 frontmatter가 없는 문서이다.

2번은 `^---$` 정규식을 통과하였는데, `^title:` 정규식을 통과하지 못한 경우에 해당한다.

3번은 비어있거나 공백만 있는 문서이므로 `[^[:space:]]`를 만족할 것이다.

## sed로 고치기

frontmatter 자체가 없는 경우엔 파일의 최상단에 frontmatter를 추가하면 된다. `sed` 명령어로
인라인으로 편집할 수 있다.

```bash
  sed -i '' "1i\\
---\\
title: ${filename%.md}\\
tags: []\\
---\\
\\
" "$filename"
```

- `-i ''` -- 옵션으로 임시 파일을 만들지 않고 파일을 제자리바꿈(*in-place replace*) 할 수 있다.
- `1i` -- i는 삽입 명령어이다. 다음에 오는 내용을 파일의 첫줄에 삽입할 수 있다.
- `\\\` -- 줄바꿈을 넣기 위한 이스케이핑. 특이하게 `1i` 다음 바로 줄바꿈이 필요하다. 이 부분이 GNU와 POSIX의 sed가
  동작이 다르다.
- `${filename%.md}` -- 변수 `$filename`의 내용을 가져오되, 끝의 `.md`는 뺀다.

frontmatter는 있지만 title만 없는 경우에는 frontmatter 블록(`---`) 중 젤 위의 블록을
`title`이 있는 것으로 대체하면 된다.

```bash
  sed -i '' "1s/^---$/---\\
title: ${filename%.md}/" "$filename"
```

## git hook으로 만들기

위의 내용을 `bin/add-frontmatter.sh`로 스크립트 파일로 만들었다. hook으로도 쓰고
그냥도 쓰고 싶어서 별도의 스크립트로 만들었다. 둘의 동작이 미묘하게 달라야 하는데:

1. 그냥 실행할 경우에는 `notes`를 검사하여 frontmatter를 고친다.
2. 훅으로 돌릴 경우에는 커밋 전 커밋 대상의 frontmatter들을 고쳐준다.

bash에서 `while read` 문을 쓰면 표준입력으로 들어온 내용을 줄마다 반복문으로 돌릴 수 있다.
이를 이용하면 스크립트는 바꾸지 않고 파이프로 던질 내용만 바꾸어서 쓸 수 있다:

```bash
# 그냥 돌릴 때에는 아래처럼
find notes -name '*.md' | ./bin/add-frontmatter.sh

# 훅으로 돌릴 때에는 아래처럼 스테이징 된 `*.md`만 가져온다.
git diff --exit-code --name-only --cached -- "*.md" | ./bin/add-frontmatter.sh
```

git hook은 git 프로젝트 폴더의 `.git/hooks` 디렉토리에 넣으면 된다. 여러 훅이 있는데
`.sample` 확장자로 샘플이 미리 준비되어 있다. 이중 `pre-commit`이 제일 적절하다고 판단하여
`pre-commit` 스크립트를 짰다.

```bash
applypatch-msg.sample*
commit-msg.sample*
fsmonitor-watchman.sample*
post-update.sample*
pre-applypatch.sample*
pre-commit.sample*
pre-merge-commit.sample*
pre-push.sample*
pre-rebase.sample*
pre-receive.sample*
prepare-commit-msg.sample*
push-to-checkout.sample*
update.sample*
```

말 그대로 커밋 전에 실행되므로 스테이징 된 파일을 대상으로 수정이 이루어질 경우
수정에 대한 `git add` 혹은 `git rm`을 해주어야 한다.

스크립트에서 표준 출력으로 처리한 파일을 뺸 후 다시 처리해도 되지만 그렇게까지 하긴 싫어서...
간편하게 `--pre-commit` 옵션을 넘기면 `git add`도 하도록 처리했다.

최종적인 `.git/hooks/pre-commit` 파일은 아래와 같다:

```bash
#!/bin/bash

git diff --exit-code --name-only --cached -- "*.md" | ./bin/add-frontmatter.sh --pre-commit
```

## 끝

별 작업 아니었지만 `sed`와 이스케이핑 등이 macOS(POSIX)와 리눅스가 달라 고생했고, bash 스크립트를 별로 쓴 경험이 없어서
괜히 시간이 걸렸다.

이미 있는 도구를 조합하여 간단히 자동화 할 수 있는 건 분명 강력하지만 적절한 테스트 방법을 찾지 못해서 나중에 애먹을 듯
싶다.

## 참고

- [hanassig/bin/add-frontmatter.sh](https://github.com/nyeong/hanassig/blob/7b9744cbee24cd3341c6665a07bdf9358afaa41f/bin/add-frontmatter.sh)