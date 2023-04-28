---
title: 식사하는 철학자 문제
description: 
date: 2023-02-24
tags:
---

![](/assets/dining-philosophers.jpg)

다섯 명의 철학자가 원탁에 둘러 앉는다. 철학자들은 생각을 하다 이따금 스파게티를 먹는다. 철학자들 사이엔 포크가 놓여 있는데, 양쪽의 포크를 모두 사용하여 식사를 한다.

1. 일정 시간 동안 생각을 한다.
2. 왼쪽의 포크를 집어든다. 포크가 사용중이면 대기한다.
3. 오른쪽의 포크를 집어든다. 포크가 사용중이면 대기한다.
4. 양쪽의 포크를 잡았다면 일정 시간 동안 식사를 한다.
5. 오른쪽 포크를 내려놓는다.
6. 왼쪽 포크를 내려놓는다.
7. 1번으로 돌아간다.

## 교착상태

이 문제는 1965년에 컴퓨터 과학자 에츠허르 데이크스트라(*Edsger W. Dijkstra*) 박사가 교착상태(*deadlock*)을 설명하기 위해 만든 것으로 알려져있다.

어느 순간 모든 철학자가 왼쪽의 포크를 집어든 순간을 상상해보자. 모든 철학자는 이미 사용중인 자신의 오른쪽 포크를 기다리기만 하고 아무것도 하지 못하는 교착상태(*deadlock*)에 빠지게 된다.

## 해결 방법

1. 자원 위계 해결법
	- 적어도 한 명의 철학자는 다른 순서로 포크를 집도록 하여 순환 의존성을 없앤다.
	- 다섯 개의 뮤텍스가 필요하다.
	- 언뜻보면 손쉽고 좋은 해결책인 것 같으나 허점이 많은데, 가령 오른쪽 포크부터 집는 철학자는 생각이 길면 밥을 절대 먹을 수 없다.
	- 또한 자원의 갯수를 미리 알아야 해결할 수 있다.
2. 타임아웃을 이용한 해결법
	- 일정 시간 동안 자원을 얻지 못하면 자원을 반환하고 처음부터 작업을 다시한다.
	- 근본적인 해결법은 아니나 빠르게 적용할 수 있는 임시방편이다.
3. 중재자 해결법
	- 포크를 감독할 웨이터를 둔다. 포크를 감독하다 포크 하나만 남으면 왼손에 포크를 쥔 철학자에게만 포크를 준다.
	- 뮤텍스 하나만 있으면 된다.
4. n-1 해결법
	- 철학자를 감독할 웨이터를 둔다. 적어도 한 명의 철학자를 기다리게 한다.
	- 뮤텍스 하나와 세마포어 하나가 있어야 한다. 
5. Chandy/Misra 해결법
	- 메시지 패싱을 이용한 해법.
	- 철학자가 서로 대화할 수 있을 경우의 해법이다. (메시지 패싱하므로)
	- MSPC를 이용하여 해결한다.

## 참고

- [데드락 (DeadLock, 교착 상태) | 👨🏻‍💻 Tech Interview](https://gyoogle.dev/blog/computer-science/operating-system/DeadLock.html)