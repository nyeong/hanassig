---
title: 한글 인코딩
description: 파인더에서 괜찮던 한글이 망가지는 이유
date: 2022-02-26
tags:
---

![](/assets/hanassig-notes-on-macos-finder.png)

![](/assets/nfd-on-helix.png)

파인더에서는 멀쩡한 파일 이름이 helix 에디터에서 망가지는 이유를 알아보자.

## 동치

[UNICODE NORMALIZATION FORMS - 1.1 Canonical and Compatibility Equivalence](https://unicode.org/reports/tr15/#Canon_Compat_Equivalence)

유니코드에서 "같음"에 대한 두 가지 정의가 있다. 정준 동치와 호환 동치다:

두 문자 시퀀스가 동일한 모양과 의미와 기능을 지닐 경우 "같다"고 할 수 있다.
이를 정준 동치(*canonical equivalence*)라고 한다.

예를 들어 `가`와 `ᄀ+ᅡ`는, 유니코드는 `U+AC00`, `U+1100, U+1161`로 서로 다르지만
이를 읽는 이는 동일하게 '가'로 읽을 것이다. 따라서 프로그램도 이를 동일한
글자로 취급하고 다뤄야 한다.

호환 동치(*compatibility equivalence*)는 이보다는 큰 범위의 "같음"이다.
모양이나 기능이 조금 다르더라도 비슷한 의미를 지녔으면 같은 글자로 취급한다.

예를 들어 `𝑓`[^1]는 `f`와 모양이 다르므로 표준 동치로는 서로 다른 문자이다.
그러나 두 문자 모두 `f`를 의미하므로 호환 동치로는 같은 문자로 취급하고 다룬다.

구글 검색은 문자열을 호환 동치하기 때문에 `𝑓`를 검색하여도 `f`를 검색한 것과
결과가 같다.

![](/assets/search-math-f-in-google.png)


[^1]: https://www.compart.com/en/unicode/U+1D453



## 정규화

[UNICODE NORMALIZATION FORMS - 1.2 Normalization Forms](https://unicode.org/reports/tr15/#Norm_Forms)

동치의 개념에서 보았듯, 유니코드에서는 같은 의미의 문자라도 여러 방법으로
표현할 수 있다. 따라서 이를 통일할 방법이 필요하며 이를
정규화(*normalization*)라고 부른다.

정규화에는 네 가지 방법이 있다.

- NFD: 정준 분해
- NFC: 정준 분해 후 정준 결합
- NFKD: 호환 분해
- NFKC: 호환 분해 후 정준 결합

대부분의 한글 표기는 호환 동치와는 무관하므로 정준 분해에 대해서만 보면 아래와
같다:

```
가(U+AC00)를 정규화하면...
NFD: → ᄀ(U+1100) + ᅡ(U+1161)
NFC: → 가(U+AC00)


ᄀ(U+1100) + ᅡ(U+1161)를 정규화하면...
NFD: → ᄀ(U+1100) + ᅡ(U+1161)
NFC: → 가(U+AC00)
```

### 뭐가 맞는가

https://unicode.org/reports/tr29/#Standard_Korean_Syllables

### macOS에서

```bash
convmv -r -f utf-8 -t utf-8 --nfc . --notest
```

### 참고

- [유니코드 등가성](https://ko.wikipedia.org/wiki/%EC%9C%A0%EB%8B%88%EC%BD%94%EB%93%9C_%EB%93%B1%EA%B0%80%EC%84%B1)
- [Unicode® Standard Annex #15](https://unicode.org/reports/tr15/)