# Helix

[helix-editor/helix](https://github.com/helix-editor/helix)

Rust로 쓴 모달 에디터.

## 특징

- selection-first 모달 에디터
  - kakoune의 영향을 받음
- tree-sitter 기반 하이라이팅
- LSP 내장

### kakoune과 다른점

내장 도구가 많다.

kakoune은 다른 도구와 함께 쓰는 것을 권장한다.
vim과 같은 윈도우 기능도 기본적으로 없고, `i3`나 `tmux` 등의 프로그램과 함께 쓰기를 권한다.

helix는 기본 설정만으로 충분히 쓸만할 것을 목표한다.[^1] 다른 에디터에서는 굳이 구현하지
않는 퍼지 파일 탐색기 등도 내장되어있다.

[^1]: https://github.com/helix-editor/helix/blob/master/docs/vision.md

## 설정

`~/.config/helix/config.toml` 파일로 설정한다.

아직 별로 할 수 있는 설정이 없긴 한데... `[editor]` 섹션에서 `line-number`는 `relative`로 설정하는 것이 편하다.
위 아래로 몇 줄 떨어져있는지 바로 보여 숫자와 명령어를 바로 조합할 수 있다.

![[helix-relative-line-number.png]]

## 자주 쓰는 키

vim과 다르게 kakoune처럼 모드 -> 조합

- `<space>`: 
  - `f`: 파일 선택기. 퍼지 파인더라 엄청 편하다
  - `b`: 버퍼 선택기
- `v`: select 모드. 현재 선택 영역을 늘리거나 줄일 때 쓴다. kakoune에서의 `shift` 키조합과 비슷.
  kakoune에서 `e`로 선택하고, 더 늘리려면 `<s-e>`를 누르면 되는데, helix에서는 `ve`를 누르면 된다.
- `g`: goto 모드
- `m`: match 모드
