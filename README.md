# 하나씩

배운 것들을 하나씩 정리합니다.

- 라이센스: [CC BY-SA](LICENSE)
- 퍼블리싱: [annyeong.me](https://annyeong.me)

## 구조

```
├── assets/ -- 이미지 등 첨부파일
├── bin/    -- 빌드 시스템 실행 파일
├── notes/  -- 마크다운 파일
├── LICENSE
└── README.md
```

## 빌드

본 저장소의 빌드 시스템은 몇가지 비표준 문법을 사용하는 유효한 마크다운 파일을
입력으로 받아 유효한 마크다운 파일로 빌드합니다.

마크다운을 기반으로 하고 있으나 몇가지 비표준 문법을 사용하고 있습니다.

- [x] 내부 링크
- [x] 동적 템플릿

### 내부 링크

```md
[[internal-link]]
```

위 문법은 `notes/internal-link.md` 파일을 가리킵니다. 컴파일하면 문서 최하단에
`[internal-link]: notes/internal-link.md` 꼴의 refer가 삽입됩니다.

### 동적 템플릿

```md
[//do]: # "template_name"
[//end]: #
```

해당 블록 내의 내용은 빌드 후 템플릿 내용으로 대체됩니다.

- recent: git commit 기준으로 최근 글을 정렬하여 보여줍니다.
