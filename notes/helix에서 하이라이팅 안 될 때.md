---
title: helix에서 하이라이팅 안 될 때
---

helix 에디터는 tree-sitter를 이용해서 하이라이팅을 한다. `language.toml` 파일에 `[[grammar]]` 부문에 아래와 같이 정의가 되어 있다:

```toml
[[grammar]]
name = "rust"
source = { git = "https://github.com/tree-sitter/tree-sitter-rust", rev = "0431a2c60828731f27491ee9fdefe25e250ce9c9" }
```

`git`은 저장소 주소, `rev`는 커밋 이름이다. 혹시 하이라이팅이 깨졌을 경우 저장소 주소와 커밋 이름을 다시 확인하고 아래 명령어로 트리시터를 업데이트한다:

```bash
hx --grammar fetch
hx --grammar build
```