# 오늘은 몇 주차? 업데이트

[오늘은 몇 주차?](https://nyeong.github.io/nth-week-today/)는 오늘이 올해의
몇 주차인지 알려주는 웹 사이트이다. 2018년 쯔음 유사-군생활을 시작하며
모든 것을 주 단위로 계획하고 움직이게 되었다. 그런데 은근 오늘이 몇 주차인지
쉽게 알려주는 서비스가 없어 만들게 되었다.

![](/2022-10-08/nth-week-today.png)

기능은 단순하다. 오늘 날짜와 오늘이 몇 주차인지 알려주고 끝이다. 처음엔 주차만
넣었는데, 오늘 날짜가 보이지 않으니 얘가 맞게 알려주는 건지 불안해져서 넣었다.
일부러 초 단위로 날짜를 업데이트하여 "잘 작동하고 있음"을 과시했다.
나름 UX에 신경썼다고 볼 수 있다.

은근 수요가 있었는지 한동안 구글에 "몇주차"만 검색해도 제일 먼저 결과가 나왔다.
그래서 나도 즐겨찾기에 등록하지 않고 편하게 구글에 검색해서 썼던 기억이 있다.
당시 주소가 `annyeong.me/nth-week-today`였는데, 생각 없이 도메인 설정을 바꾸며
주소가 바뀌고, 구글 검색 설정에 반영해주지 않아 아쉽게도 검색 결과 순위에서
내려갔다.

## 몇 주차 기준이 뭔가요?

[노트](/notes/side-projects/nth-weekday)에 자세히 정리하였다.

간단히 요약하면 날짜와 시간을 표현하는 국제 표준 [ISO 8601]에 의하여, 목요일을
기준으로 주차를 센다. 즉 $n$주차는 $n$번째 목요일이 포함된 주이다.
따라서 재밌게도 1월 1일이 금요일이라면 그 날은 올해의 첫주차가 아니게 된다.
대신 지난해의 마지막 주차가 된다.

| Week    | Mon | Tue | Wed | *Thu*  | Fri | Sat | Sun |
| ------- | --- | --- | --- | ------ | --- | --- | --- |
| **W53** |     |     |     |        | 01  | 02  | 03  |
| **W01** | 04  | 05  | 06  | **07** | 08  | 09  | 10  |

영어권에서는 week number 혹은 ISO week date로 부르고, **W**를 붙여 표기하는 듯
하다. 예컨데 22년도 4주차면 2022W4와 같이 쓴다. 관련 [위키]에 내용이 잘
정리되어 있다.

[위키]: https://en.wikipedia.org/wiki/ISO_week_date
[ISO 8601]: https://ko.wikipedia.org/wiki/ISO_8601

## 이슈 처리하기

사실 이 [저장소]는 2018년에 저장소 팔 때 이후로는 들어간 적이 없다. 오랜만에
우연히 접속하니 [누군가 맞춤법을 고쳐주었다][pr-01]. 오랫동안 사이트의 이름이
**오늘은 몇주차**였는데, **몇 주차**로 띄어쓰기가 맞다는 지적이었다.

인생 처음으로 받은 풀 리퀘스트인데 거진 1년이 지나서야 발견하고 부랴부랴 
머지하였다.

[pr-01]: https://github.com/nyeong/nth-week-today/pull/1
[저장소]: https://github.com/nyeong/nth-week-today

[또 다른 이슈][pr-02]는 다른 저장소에 올라왔다. 종종 잘 쓰고 있었는데, 링크가
깨졌다는 이슈였다. 이슈를 열어주신 분은 이 오류 때문에 GitHub 계정까지 새로
만드신 것 같았다.

[pr-02]: https://github.com/nyeong/hanassig/issues/15

상기했다시피 본래 `annyeong.me/nth-week-today`로 접속 가능했으나 GitHub Pages에
연결된 도메인을 바꾸며 `nyeong.github.io/nth-week-today`로 접속해야해서 생긴
문제였다.

여러가지 방법이 있겠으나, 이 블로그에 리다이렉션을 추가하는 것이 가장 빠를
것으로 판단하고 바로 작업하였다.

오랜만에 업데이트를 위하여 저장소에 접속해보니 메인 브랜치가 `master`이다.
메인 브랜치부터 `main`으로 다시 이름지었다.

![](/2022-10-08/rename-branch.png)

GitHub 브랜치 설정에서 원격 저장소의 브랜치 이름을 바꾸고, 로컬에서는 아래의
명령어로 원격 저장소를 다시 설정해준다.

```bash
# master를 main으로 바꾸기
git branch -m master main
# origin(github 리모트 저장소)의 변경사항 받아오기
git fetch origin
# origin/main과 main을 연결하기
git branch -u origin/main main
# HEAD 설정하기
git remote set-head origin -a
```

지금 이 블로그는 [도큐사우르스](https://docusaurus.io/) 프레임워크로 만들었는데
`src/pages` 밑에 `.md`, `.tsx` 따위를 만들면 파일 이름으로 바로 접속할 수 있는
페이지를 손쉽게 만들 수 있다. 이 경우는 `annyeong.me/nth-week-today`로의
접속을 다뤄야 하므로 `nth-week-today.tsx`를 만들어준다.

```diff
src/
├── components/
├── css/
└── pages/
   ├── index.md
+  └── nth-week-today.tsx
```

각 페이지는 리엑트로 렌더한다. 리엑트는 잘 모르지만, `componentDidMount`와
비슷한 역할을 [useEffect](https://reactjs.org/docs/hooks-effect.html)로
할 수 있다고 한다. 혹시 `window.location.href`를 변경하는 것으로 리다이렉션이
안 될 경우를 대비하여 사용자가 클릭할 수 있는 링크도 넣는다:

```tsx title="src/pages/nth-week-today.tsx"
import React, { useEffect } from 'react'
const siteUrl = "https://nyeong.github.io/nth-week-today/"

export default () => {
  useEffect(() => {
    window.location.href = siteUrl;
  });

  return (
    <Layout>
      <Link to={siteUrl}>오늘은 몇 주차?</Link> 사이트로 이동합니다.
    </Layout>
  )
}  
```

수동으로 테스트해보니 잘 작동하여 커밋-푸쉬하였다. 

## 오픈 그래프로 결과 미리 알려주기

여기까지 해보니 조금 욕심이 생겼다. 웹 사이트를 소셜 미디어로 공유하면 작게
미리보기를 띄워주는데, 여기서 몇 주차인지 결과를 미리 알 수 있으면 좋겠다는
생각이 들었다.

![카카오톡으로 "오늘은 몇 주차"를 공유할 경우의 화면. 오늘은 몇 주차? 오늘은 올해의 몇 번째 주인가?](/2022-10-08/og-old-example.jpeg)

현재 띄워주는 미리보기는 사이트의 제목과 간단한 설명만 나온다.
[오픈 그래프 프로토콜](https://ogp.me/)을 이용하여 간단하게 제목과 설명을
넣었다. 여기서 몇 주차인지 알 수 있다면 링크를 누르지 않아도 알 수 있으니
편리할 것이다.

기존의 관련 코드는 아래와 같다:

```html title="index.html"
<meta property="og:title" content="오늘은 몇 주차?">
<meta property="og:description" content="오늘은 올해의 몇 번째 주인가요?">
```

임베디드 템플릿 엔진을 쓰면 저 내용을 편리하게 바꿀 수 있다. 엘릭서 공부 겸
엘릭서를 활용할 예정이기에 [EEx](https://hexdocs.pm/eex/1.14/EEx.html) 문법에
맞게 고쳐준다.

```html title="index.html.eex"
<meta property="og:title" content="<%= @og_title %>">
<meta property="og:description" content="<%= @og_description %>">
<meta property="og:type" content="<%= @og_type %>">
<meta property="og:url" content="<%= @og_url %>">
<meta property="og:image" content="<%= @og_image %>">
```

이제 엘릭서 코드를 이용하여 `<%= @variable %>` 영역을 다른 문자열로 손쉽게
대치할 수 있다.

```elixir
source = "src/index.html.eex"
html = EEx.eval_file(source, assigns: [
  og_title: "오늘은 몇 주차?",
  og_type: "website",
  og_url: baseurl,
  og_description: "오늘은 올해의 #{week_number}번째 주입니다!",
  og_image: image
])
File.write(dest, html)
```

주차가 바뀔 때마다 엘릭서 코드를 실행하기만 하면 된다. GitHub Action을 이용하면
GitHub에서 이 작업을 대신 해준다.

```yml title=".github/workflows/build.yml"
# 많이 생략함
name: Build Pages

on:
  schedule:
  - cron: 0 0 * * 0 # 매주 일요일 0시 0분마다 실행

jobs:
  build:
    name: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:

    - uses: actions/checkout@v3
    - name: Set up Elixir # for generate open graphs
    - name: build
      run: elixir bin/build.exs
    - name: Setup Pages
      uses: actions/configure-pages@v2
    - name: Upload artifact
      uses: actions/upload-pages-artifact@v1
      with:
        path: 'dest'
    - name: Deploy to GitHub Pages
      id: deployment
      uses: actions/deploy-pages@v1  
```

퍼블리싱해도 바로 카카오톡에서 결과가 반영되지는 않는데, 아래의 주소에서 기존의
썸네일 캐싱을 지워주어야 한다.

https://developers.kakao.com/tool/debugger/sharing

![](/2022-10-08/new-og-example.jpeg)

[Iframely](http://debug.iframely.com/) 사이트에서 다른 사이트에서 어떻게
파싱되는지 볼 수도 있다.

## 기타

생각나는 대로 빠르게 구현해서 몇 가지 문제가 예상된다.

먼저 소셜 미디어 서비스에서 페이지를 캐싱할 경우, 실제의 주수(*week number*)와
다른 주수가 미리보기 될 수 있다.

별 다른 계산 없이 갱신 시기를 잡아, 실제 시간과 표기되는 주수가 일치하지 않을
수 있다.

엘릭서로 구현하였는데, 바뀌는 내용은 실질적으로 숫자 뿐이 없으니 의존성 없이 
셸 스크립트로 작성하는 것이 더 좋을 법하다.

이 문제들은 실제로 문제가 생기면 해결하기로 하자