---
title: Git branch 이름짓기
date: 2023-04-28
tags:
  - git
---

## branch 전략

- git flow
- github flow

## master와 main

master/slave, blacklist/whitelist와 같은 차별적 은유가 함유된 IT 전문용어를 
새롭게 바꾸는 운동이 조지 플루이드 사망 사건 이후 대두되었습니다. 이에 많은
테크 팀이 동참하여 여러 대체 단어가 제시되었습니다. [^1]
이를 [포용적 이름짓기](https://inclusivenaming.org/)라고 합니다.

GitHub에서는 기본 브랜치 이름이 master에서 main으로 바뀌었습니다. 특별히 바꾸지
않으면 GitHub에서 생성한 저장소의 기본 브랜치는 `main`입니다.

[github/renaming](https://github.com/github/renaming)

### 로컬 기본 브랜치 이름 설정

아래의 명령어로 `git`의 기본 브랜치 이름을 `main`으로 바꿀 수 있습니다:

``` bash
$ git config --global init.defaultBranch main
```

자주 쓰는 설정이므로 따로 저장해두면 편리합니다. 저는 [nyeong/.dotfiles](https://github.com/nyeong/.dotfiles)
저장소에 이를 저장해두고 새로 개발환경을 설정할 때에 클론 후 심볼릭 링크하고 있습니다.
다른 개발환경 설정들도 동일하게 관리하면 편리합니다: [[devenv]]

``` bash
# 
$ git clone https://github.com/nyeong/.dotfiles ~/.dotfiles
$ ln -sf ~/.dotfiles/git/config ~/.config/git/config
```

## 참고

- [[devenv]]

[^1]: [Linux team approves new terminology, bans terms like 'blacklist' and 'slave'](https://www.zdnet.com/article/linux-team-approves-new-terminology-bans-terms-like-blacklist-and-slave/)
