---
title: 운영체제
description:
date: 2023-02-24
tags:
---

“운영체제: 아주 쉬운 세 가지 이야기”에서는 운영체제의 근간을 세 가지 개념으로 나눈다.

1. 가상화
2. [[concurrency]] (번역본에서는 병행성으로 번역되었다.)
3. 영속성

- [[unix-signal]]

## 멀티태스킹

스케줄링 방식에 있어, 제어권을 누가 갖느냐로 크게 둘로 나눈다.

### 협력형 멀티태스킹

Cooperative multitasking. 혹은 비선점(*non-preemptive*) 멀티태스킹으로 부르기도 한다.

Windows 3.1, Mac OS 9 등 고전 운영체제에서 사용했던 방법으로 운용프로그램이 자발적으로 제어권을 반환하는 방법. 운용프로그램이 제어권을 독점할 문제가 있다.

### 선점형 멀티태스킹

Preemptive multitasking.

운영체제의 스케줄러에 의하여 제어권을 관리하는 방법. 상당히 짧은 시간에 한하여 제어권을 인계하고 도로 가져간다. 오늘날 대부분의 운영체제에서 사용한다.

구현을 위하여 하드웨어 타이머, 스케줄러 등이 필요하다.

### 용어에 대하여

언뜻 보면 선점형 멀티태스킹은 먼저 제어권을 선점한 프로세스가 맘껏 연산장치를 쓸 수 있을 것처럼 보인다. 실은 스케줄러에 의해 제어권을 관리한다.

일본어권에서는 선점형이라는 말보다는 preemptive multitasking을 그대로 음차하여 プリエンプティブマルチタスク라고 부르거나 非協調的(비협력적)이라고 부르는 듯하다.

협력적 멀티태스킹을 疑似(의사) 멀티태스킹이라고 부르기도 한다.

> The term "preemptive multitasking" is sometimes mistakenly used when the intended meaning is more specific, referring instead to the class of scheduling policies known as _time-shared scheduling_, or _[time-sharing](https://en.wikipedia.org/wiki/Time-sharing "Time-sharing")_. - [Preemption (computing)](<https://en.wikipedia.org/wiki/Preemption_(computing)>)

## 참고

- [리눅스 및 커널프로그래밍 - 금오공과대학교 | KOCW 공개 강의](http://www.kocw.net/home/search/kemView.do?kemId=1266434)
- [국민대학교 OCW](https://ocw.kookmin.ac.kr/course/230)
- 반효경, [운영체제](http://www.kocw.net/home/search/kemView.do?kemId=1046323), 이화여자대학교, 2014
- [ostep-translations/korean at master · remzi-arpacidusseau/ostep-translations · GitHub](https://github.com/remzi-arpacidusseau/ostep-translations/tree/master/korean)