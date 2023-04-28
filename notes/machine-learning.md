---
title: 🤖 기계학습
description: 기계학습의 개론적인 갈래를 이해하기 위한 문서
date: 2023-02-24
tags: []
---

주어진 데이터를 이용하여 문제를 해결하기 위해 최적의 모델을 찾는 학문.

## 종류

- 지도학습(supervised learning) — 정답이 주어지는 학습
	- 분류(classification)
	- 회귀(regression)
- 비지도학습(unsupervised learning) — 정답이 주어지지 않는 학습
	- 클러스터링(clustering)
- 자기지도학습(SSL; Self-Supervised Learning) — 정답이 없을 경우 직접 달면서 학습
	- 단어 임베딩 등
- 강화학습(reinforcement learning) — 행동을 통해 보상을 얻으며 학습

### 지도학습

데이터에 정답 $y$가 주어지는 경우 지도학습 알고리즘을 쓸 수 있다.

- 분류 — 예측하고자하는 레이블이 이산적일 경우 **분류** 문제이다.
	- 스팸이거나 아니거나. 글의 카테고리가 무엇인지 등.
	- KNN, SVM, 의사 결정 트리 등을 이용하여 해결한다.
- 회귀 — 예측하고자하는 값이 연속적일 경우 **회귀** 문제이다.

## 과정

1. 데이터를 수집한다.
2. 데이터를 분석하여 파악하고 학습에 맞게 전처리한다.
3. 적절한 모델을 세워서 학습한다.
4. 학습 결과에 대해 평가한다.
5. 반복

## 평가

### 혼동행렬

알고리즘의 정확성을 평가하기 위한 도구.

| 구분      | 예측 참 (P) | 예측 거짓 (N) |
| --------- | ------- | --------- |
| 실제 참   | TP      | FN        | 
| 실제 거짓 | FP        |  TN         |

- $TP$; True Positive — 참양성 혹은 참긍정
- $FP$; False Positive — 위양성 혹은 거짓긍정
- $FN$; False Negative — 위음성 혹은 거짓부정
- $TN$; True Negative — 참음성 혹은 참부정

위 값을 이용하여 정밀도, 재현율, 정확도를 구하여 알고리즘을 평가한다:

- 정밀도(precision) — 참으로 예측한 것이 얼마나 맞는가
	$P=\frac{TP}{TP+FP}$
- 재현율(recall) — 실제로 참인 것을 얼마나 맞추는가
	$R = \frac{TP}{TP+FN}$
- 정확도(accuracy) — 정답을 얼마나 맞추는가
	$\text{ACC}=\frac{TP+TN}{TP+TN+FP+FN}$
- $F_1$ 값 — $F_1 = \frac{2PR}{P+R}$

### 과적합과 과소적합

모델이 데이터를 과하게 학습한 경우 **과적합**(overfitting)이라고 한다.
- 학습 데이터에서는 높은 성능을 발휘하지만 평가 데이터에서는 성능이 떨어진다.
- dropout, early stopping을 활용한다.

모델이 충분히 데이터를 학습하지 못한 경우 **과소적합**(underfitting)이라고 한다.
- 학습 데이터에서도 높은 성능을 발휘하지 못한다.

## 참고

- [Team-Neighborhood/I-want-to-study-Data-Science](https://github.com/Team-Neighborhood/I-want-to-study-Data-Science)
- 유원준, [딥 러닝을 이용한 자연어 처리 입문](https://wikidocs.net/book/2155). WikiDocs, 2022.