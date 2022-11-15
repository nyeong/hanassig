# macOS 추천 앱

## maccy

[maccy](https://maccy.app/)

클립보드 히스토리 도구. 오픈소스고 `brew cask`로 쉽게 설치할 수 있다.

## hammerspoon

[hammerspoon](https://www.hammerspoon.org/)

lua 언어를 이용한 자동화 도구.

특정 프로그램에서 ESC 누를 시 영문 IME로 변경하기 위해서 쓰고 있다.
-- [설정](https://github.com/nyeong/.dotfiles/tree/master/hammerspoon)

### 참고

- [Hammerspoon - 기계인간](https://johngrib.github.io/wiki/hammerspoon/)

## karabiner-elements

[Karabiner-Elements](https://karabiner-elements.pqrs.org/)

키보드 커스터마이즈 도구. 키보드 동작을 간단하게 매핑할 수 있다.
아래와 같은 동작을 위해 쓰고 있다:

1. `caps-lock`을 짧게 누르면 ESC로 동작한다.
2. `caps-lock`을 누르고 있다면
   1. H, J, K, L이 각각 좌, 하, 상, 우로 동작한다. (vim arrow binding)
   2. `back-space` 키가 `delete` 키로 동작한다.

-- [설정](https://github.com/nyeong/.dotfiles/blob/master/karabiner/assets/complex_modifications/nyeong.json)

## raycast

[raycast](https://www.raycast.com/)

![raycast 사용화면](raycast.png)

텍스트 기반 앱 런처. macOS의 spotlight나 Alfred를 대체할 수 있다.
개인 사용자용은 무료고, 별다른 기능 제약도 없다.
확장 기능을 추가할 수 있다는 것이 장점이다.

## dozer

[Mortennn/Dozer](https://github.com/Mortennn/Dozer)

메뉴바 아이콘을 깔끔하게 가릴 수 있는 앱이다.
`brew cask`로 간편하게 설치할 수 있다.

## yabai

[koekeishiya/yabai](https://github.com/koekeishiya/yabai)

macOS에서 쓸 수 있는 타일링 윈도우 매니저. [skhd]와 함께 쓰면 키 조합만으로
윈도우를 관리할 수 있어 편리하다.

[skhd]: https://github.com/koekeishiya/skhd