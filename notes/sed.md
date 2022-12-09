---
title: "sed"
---
# sed

CLI에서 파일을 편집하는 도구.

기본적으로는 표준입출력으로 반환된다.

##  캡처 그룹

`\( \)` 구문을 이용하여 캡처 그룹을 만들고, `\1` 구문으로 가져온다.

```bash
echo capture this | sed 's/\(capture\) this/\1 that/'
```

## 예시

마크다운 파일의 헤더를 한 단계씩 더 들여쓰기

```bash
rg '^#' -l | tr '\n' '\0' | xargs -0 sed -i '' -E 's/^#/##/g'
```

마크다운 파일에 파일 제목으로 `h1` 헤더 추가하기

```sh
fd -e "md" --exec sed -i '' '1s/^/# {/.}\n\n/' "{}"
```

마크다운 파일에 frontmatter 추가하기

```sh
fd -e 'md' --exec zsh -c 'sed -i "" "1s/^/---\ntitle: \"{/.}\"\n---\n/" "{}" | head -n 5'
```

### wikilink 스타일을 마크다운 링크로 바꾸기

문제 정의

- 마크다운 파일 내의 `[[fine name]]`을 `[file name](file path)`로 바꾸기.
- 다행히 파일 이름이 곧 문서 이름이다.
- 더 정확히는 이런 종류들이 있음
	- `![[image name]]` 구문의 이미지 이름
	- 글 내용 중 설명을 위하여 백틱( \` )으로 둘러 싼 링크 구문도 있다.
	- 글 내의 헤더에 링크를 걸기 위하여 `[[#header name]]`
	- 링크와 보여지는 이름을 다르게 하기 위하여 `[[file name|shown name]]`
	- 위의 두 경우가 함께 있는 링크 `[[file name#header name|shown name]]`
- 

## 참고

- 이종립, [새로 입사한 개발자가 프로젝트에 기여하는 방법 한 가지](https://helloworld.kurly.com/blog/fix-style-with-command/), 2020
- [Fetching Title#uf3k](https://catonmat.net/proof-that-sed-is-turing-complete)