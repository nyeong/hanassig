---
title: 파이썬
date: 2023-04-21
tags: [프로그래밍_언어, 파이썬]
---

## 이상한 점, 불편한 점

- `''.join(arr)`은 아무리 써봐도 어색하다.

### \_\_name\_\_ == '\_\_main\_\_'

### 표현식 기반 언어가 아니다.

- 기본적으로 반환값이 없음.
- 항상 무슨 값이든 반환하는 ruby 같은 표현식 기반 언어와는 대조적.
- 간단한 대입연산만 해도 `a = "hello"` 하면 반환값이 없으므로 REPL에 아무것도
  출력되지 않는다.
- 표현식 기반이 아니다보니 메소드 끝에 명시적으로 `return`을 써줘야 한다.

### 전역 상태를 쓰는 라이브러리

일부 라이브러리의 상태를 설정하는 함수들이 상태를 어디에 담는지 모르겠다.

pyplot을 예로 들면 아래처럼 `barplot`, `title` 함수로 출력할 그래프의 상태를
설정하는데, 그 값이 어디에 저장되고 `show`가 어떻게 참조하는지를 알 수가 없다.

```python
import seaborn as sns
import matplotlib.pyplot as plt
sns.barplot(x=[1, 2, 3, 4], y=[0.7, 0.2, 0.1, 0.05])
plt.title("Bar Plot")
plt.show()
```

아래처럼 상태를 따로 담는 게 내 직관으로는 자연스러운데 파이썬은 반대이다.

```python
# 그래프를 그릴 정보를 담은 값을 만들고
p = sns.barplot(title="Bar Plot", x=[1, 2, 3, 4], y=[0.7, 0.2, 0.1, 0.05])

# 그걸 주면서 그리라는 게 자연스럽지 않나?
plt.show(p)
```

다른 라이브러리는 또 직관대로라 헷갈린다.

```python
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager

# 직관대로 driver 먼저 만든다.
driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()))
driver.get('https://www.weather.go.kr/w/weather/forecast/short-term.do')
```

### 고차 함수

아래와 같은 문자열이 있을 때, 숫자의 리스트로 만들고 싶다고 하자:

```
text = '20℃\n20℃\n21℃\n21℃\n19℃\n18℃\n16℃\n15℃\n14℃\n14℃\n13℃\n12℃\n12℃\n11℃\n11℃\n10℃\n10℃\n12℃'
```

파이썬으론 아마 아래처럼 list comprehension을 쓰는 게 자연스러울 것 같다:

```python
ns = [int(n[:-1]) for n in text.split('\n')]
```

리스트 컴프리헨션도 좋긴 한데, 나는 루비처럼 함수의 흐름대로 체이닝하는 편이
내 사고방식과 흐름이 같아서 편리하다.

```ruby
text.split('\n').map(&:to_i)
```

엘릭서로 해도 파이프 연산자(`|>`) 덕분에 사고 흐름은 같다. 대상을 제일 앞에,
구체적 동작을 뒤에 동작 순서대로 서술한다. 모듈 이름 때문에 장황스러워지긴 한다.

```elixir
text
|> String.split("\n")
|> Enum.map(fn n -> String.replace(n, "℃", "") |> String.to_integer() end)
```

## 참고

- [파이썬이 메모리를 관리하는 방법](https://imadethiscookie.wordpress.com/2021/04/27/python-memory-management/)
