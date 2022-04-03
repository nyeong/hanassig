# Kakoune

https://kakoune.org/

모달 텍스트 편집기.

## 특징

- 선택 → 동작 순으로 명령어를 입력
- 강력한 선택 영역 조작 기능 (다중선택, Regex, 텍스트 오브젝트 등)
- 강력한 텍스트 조작 기능 (정렬, 돌리기, 대소변환, 들여쓰기, 파이프라이닝 등)
- 외부 프로그램과 상호작용이 쉬움
- 단점: 사용자 수가 적고 vim에 비해 커뮤니티 활성화가 안 되어 있다. (플러그인이 없음...)

## 설정

[mawww/kakoune#configuration-autoloading](https://github.com/mawww/kakoune#configuration-autoloading)

kakoune은 아래 두 가지 방법으로 설정을 불러온다.

1. `$XDG_CONFIG_HOME/kak/autoload` 디렉토리 내부의 모든 `*.kak` 파일을 불러온다.
2. `$XDG_CONFIG_HOME/kak/kakrc` 파일을 불러온다.

`$XDG_CONFIG_HOME/kak/autoload` 디렉토리를 만들면 기본 설정을 불러오지 않으므로
아래의 방법으로 기본 설정을 심볼릭 링크한다.

```
# brew로 설치했을 경우

$ mkdir -p ~/.config/kak/autoload/
$ ln -sf $(brew --prefix)/share/kak/autoload ~/.config/kak/autoload/default.d
```

### 플러그인

[andreyorst/plug.kak](https://github.com/andreyorst/plug.kak)

`plug.kak` 플러그인으로 플러그인을 관리한다.

```kakrc
source "%val{config}/plugins/plug.kak/rc/plug.kak"
plug "andreyorst/plug.kak" noload
```

- [hl-lyouhei/kakoune-surround](https://github.com/hl-lyouhei/kakoune-surround): 선택영역을  둘러싼 문자나 괄호쌍을 편리하게 입력, 삭제, 수정할 수 있다.
- [andreyorst/fzf.kak](https://github.com/andreyorst/fzf.kak): `fzf`를 활용하여 파일을
  편리하게 열 수 있다.
- [kak-lsp/kak-lsp](https://github.com/kak-lsp/kak-lsp): LSP 클라이언트. LSP 서버를
  지원하는 언어와 kakoune을 연결하여 자동완성, goto, 문서보기 등의 편리한 기능을 쓸 수
  있게 해준다.

### elixir-ls 설정

먼저 `elixir-ls`를 내려받고 빌드한다.

```
$ mkdir -p ~/.local/share
$ git clone https://github.com/elixir-lsp/elixir-ls ~/.local/share/elixir-ls
$ cd ~/.local/share/elixir-ls/
$ mix deps.get && mix compile && mix elixir_ls.release -o release
```

이제 `~/.local/share/elixir-ls/release/language_server.sh` 파일을 실행시켜서 언어 서버를
켤 수 있다.

다음으로 `kak-lsp`가 `elixir`를 인식하면 위 파일을 이용하여 언어 서버를 실행하도록 해주어야 한다.
`kak-lsp`의 기본 설정은 [dirs 크레이트](https://docs.rs/dirs/2.0.1/dirs/fn.config_dir.html)에 적힌 위치에 있다.

`elixir` 섹션의 기본값은 아래와 같다:

```toml
[language.elixir]
filetypes = ["elixir"]
roots = ["mix.exs"]
command = "elixir-ls"
settings_section = "elixirLS"
```

이를 아래와 같이 바꾼다:

```toml
command = "sh"
args = ["~/.local/share/elixir-ls/release/language_server.sh"]
```
