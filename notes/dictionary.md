---
title: 딕셔너리
description: 
date: 2023-02-24
tags:
---

검색, 삽입, 삭제 세 가지 연산을 지원하는 동적 집합을 딕셔너리(dictionary)라고 부른다.

흔히 딕셔너리라고 하면 아래와 같이 키와 그에 대응하는 값들이 모인 키-값 쌍의 모음을 떠올린다:

```python
dic = {'alice': [1, 2, 3], 'bob': 42}
## dic['alice'] = [1, 2, 3]
```

ADT로서 정의하고자 하는 딕셔너리는 이보다 더 일반적이다. 파이썬의 딕셔너리도 검색, 삽입, 삭제가 가능하므로 딕셔너리 ADT의 구현체라고 할 수 있다. 더 넓게 보면 배열이나 연결 리스트와 같은 선형 리스트나 이진 탐색 트리도 마찬가지로 검색, 삽입, 삭제가 가능한 동적 집합이므로 딕셔너리이다.

수많은 일반적인 데이터 처리는 딕셔너리의 연산으로 처리할 수 있다. 딕셔너리라는 ADT를 정의함으로서 일반적인 데이터 처리 알고리즘을 표현할 기준이 생기고, 또한 어떤 구현체가 해당 알고리즘에 효과적인지 손쉽게 분석할 수 있다.

그래도 딕셔너리면 키-값 쌍이여야 하는 거 아니야? 선형 리스트면 키-값 쌍이 아니잖아? 라는 생각이 든다면 맘 편히 키값이 값과 같다고 생각해도 좋고, 키가 인덱스와 같다고 생각해도 좋다.

```ruby
linear_list_0 = { 0 => '철수', 1 => '영희', 2 => '명수', 3 => '상수'}
linear_list_1 = { '철수' => '철수', '영희' => '영희', '명수' => '명수', '상수' => '상수'}
linear_list_2 = ['철수', '영희', '명수', '상수']
```

### 연산

아래의 정의는 "The Algorithm Design Manual"과 "Introduction to Algorithms"을 참고하였다.

- $\operatorname{Search}(D, k)$: 딕셔너리 $D$에서 키 $k$에 대응하는 원소의 포인터를 반환한다.
- $\operatorname{Insert}(D, x)$: 딕셔너리 $D$의 집합에 포인터 $x$가 가리키는 원소를 추가한다.
- $\operatorname{Delete}(D, x)$: 딕셔너리 $D$에서 포인터 $x$가 가리키는 원소를 삭제한다. (키값이 아닌 원소 $x$에 대한 포인터임에 유의한다.)
- $\operatorname{Min}(D)$: 딕셔너리 $D$에서 가장 키값이 작은 원소을 반환한다.
- $\operatorname{Max}(D)$: 딕셔너리 $D$에서 가장 키값이 큰 원소을 반환한다.
- $\operatorname{Successor}(D, x)$: 정렬된 딕셔너리 $D$에서 포인터 $x$가 가리키는 원소의 다음 원소를 반환한다.
- $\operatorname{Predecessor}(D, x)$: 정렬된 딕셔너리 $D$에서 포인터 $x$가 가리키는 원소의 이전 원소를 반환한다.

위의 연산은 딕셔너리의 내용을 바꾸는 수정연산($\operatorname{Insert}$, $\operatorname{Delete}$)과 내용을 바꾸지 않는 탐색연산($\operatorname{Search}$, $\operatorname{Max}$, $\operatorname{Min}$, $\operatorname{Successor}$, $\operatorname{Predecessor}$)으로 나눌 수 있다.

### 구현

- 선형 리스트로 구현할 수 있다.
- 이진 탐색 트리를 이용하여 구현할 수 있다.
- 해시 테이블을 이용하여 구현할 수 있다.

#### 선형 리스트

선형 리스트로 구현한다면 정렬의 유무에 따라 효과적인 연산이 달라진다. 정렬하지 않을 경우 수정연산이 효과적이고, 정렬할 경우 탐색연산이 효과적이다.

| 연산                                 | unsorted array | sorted array | unsorted linked list (s/d) | sorted linked list (s/d) |
|------------------------------------|:--------------:|:------------:|:--------------------------:|:------------------------:|
| $\operatorname{Search}(D, k)$      |     $O(n)$     | $O(\log n)$  |      $O(n)$ / $O(n)$       |     $O(n)$ / $O(n)$      |
| $\operatorname{Insert}(D, x)$      |     $O(1)$     |    $O(n)$    |      $O(1)$ / $O(1)$       |     $O(n)$ / $O(n)$      |
| $\operatorname{Delete}(D, x)$      |     $O(1)$     |    $O(n)$    |     $O(n)^*$ / $O(1)$      |    $O(n)^*$ / $O(1)$     |
| $\operatorname{Min}(D)$            |     $O(n)$     |    $O(1)$    |      $O(1)$ / $O(n)$       |     $O(1)$ / $O(1)$      |
| $\operatorname{Max}(D)$            |     $O(n)$     |    $O(1)$    |      $O(1)$ / $O(n)$       |    $O(1)^*$ / $O(1)$     |
| $\operatorname{Successor}(D, x)$   |     $O(n)$     |    $O(1)$    |      $O(n)$ / $O(n)$       |     $O(1)$ / $O(1)$      |
| $\operatorname{Predecessor}(D, x)$ |     $O(n)$     |    $O(1)$    |      $O(n)$ / $O(n)$       |    $O(n)^*$ / $O(1)$     |

연결 리스트도 단순이냐, 이중이냐에 따라 연산의 비용이 달라진다. 단순일 경우 다음 노드를 찾기 쉬우나, 이전 노드를 찾기 위해서는 결국 순회해야 하므로 $O(n)$의 비용이 든다.
이중 연결 리스트는 이전 노드에 대한 정보도 함께 갖고 있으므로 삭제 연산의 비용이 $O(1)$으로 줄어들며, 정렬되었을 경우 $\operatorname{Predecessor}$ 연산도 $O(1)$으로 줄어든다.

#### 이진 탐색 트리

| 연산                                 | binary search tree |
|------------------------------------|:------------------:|
| $\operatorname{Search}(D, k)$      |       $O(\log n)$       |
| $\operatorname{Insert}(D, x)$      |       $O(\log n)$       |
| $\operatorname{Delete}(D, x)$      |       $O(\log n)$       |
| $\operatorname{Max}(D)$            |       $O(\log n)$       |
| $\operatorname{Min}(D)$            |       $O(\log n)$       |
| $\operatorname{Successor}(D, x)$   |       $O(\log n)$       |
| $\operatorname{Predecessor}(D, x)$ |       $O(\log n)$       |

### 참고

- Steven S.Skiena. "The Algorithm Design Manual" 2008.
- Thomas H.Cormen et al. "Introduction to Algorithms" 2009.
