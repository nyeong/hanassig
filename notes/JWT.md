---
title: JWT
tags: [웹]
---

JWT; JSON Web Token은 인증, 허가 수단 등을 암호화하여 JSON 구조로 주고 받을 수 있는 웹 표준이다. 디지털 서명되어 신뢰성이 높은 것이 특징이다.

표준인 [RFC 7519](https://datatracker.ietf.org/doc/html/rfc7519)에 따르면 “jot”라고 읽는다.

## 특징

- 검증에 상태가 필요하지 않기 때문에 무상태 통신과 어울린다.
- 토큰의 내용 자체는 암호화 되지 않는다. 암호화는 신뢰성을 담보할 뿐이다.
- 담는 정보의 양에 따라 토큰의 크기가 커진다.

## 흐름

```mermaid
sequenceDiagram
	participant 클라이언트
	participant 인증 서버
	participant 자원 서버
	클라이언트->>인증 서버: 1. 토큰 요청
	activate 인증 서버
	인증 서버->>클라이언트: 2. 토큰 발급
	deactivate 인증 서버
	클라이언트->>자원 서버: 3. 자원 요청
```

### 토큰 요청

클라이언트가 인증 서버에게 인증에 필요한 정보를 넘겨 토큰을 요청한다. 인증 수단으로 활용하는 경우, username과 password를 넘겨 인증 토큰을 발급받을 수 있다.

### 토큰 발급

클라이언트의 요청을 검증하여 유효한 경우 토큰을 발급한다.

토큰은 header, payload, signature로 이루어져있는 문자열이다.

- header — 암호화 알고리즘의 종류와 토큰의 종류 명시한다.
- payload — 토큰에 담을 데이터
- signature — 전자서명

header와 payload는 JSON이며, signature는 이를 명시된 해시 알고리즘으로 암호화한 것이다. 이에 대한 자세한 설명은 아래 [[#구현]] 참고.

토큰은 최종적으로 base64로 인코딩되어 아래와 같은 문자열이 되어 클라이언트에게 보내진다. `.`을 구분자로 `header.payload.signature` 형태로 이루어져있다. 아래는 그 예시이다:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkhlbGxvIiwiaWF0IjoxNTE2MjM5MDIyfQ.r49ULQib9F6NVK7ReufLCEanG0m9rm76M2I5Ivjhb5c
```

### 자원 요청

클라이언트는 발급받은 토큰을 이용하여 자원 서버에 원하는 자원을 요청한다. 아래처럼 HTTP 헤더에 `Authorization` 필드를 이용하여 토큰을 전달한다.

```
Authorization: Bearer <token>
```

## 구현

### Header

헤더는 토큰의 타입과 암호화 알고리즘이 담는 JSON이다.

```elixir
header = %{
  alg: "ES256",
  typ: "JWT"
}

encoded_header = header
  |> Jason.encode!()
  |> Base.url_encode64(padding: false)
```

이 암호화 알고리즘을 JWA; JSON Web Algorithms라고 부르며 [RFC 7519](https://datatracker.ietf.org/doc/html/rfc7519)로 표준화되어있으며, 해당 문서 3.1절에 `alg` 값이 정의되어 있다.

`HS256`은 구현체가 기본적으로 구현해야하는 알고리즘이며 대칭키 방식이다. `RS256`과 `ES256`은 구현에서 권장하는 알고리즘이며 비대칭 암호화 방식이다.

비대칭 암호화 방식을 이용할 경우, 토큰을 발급할 때에는 비밀키로 암호화하고 발급한 토큰을 검증할 때에는 공개키로 복호화 하면 된다. 자세한 내용은 아래의 [[#Signature]] 참고.

- `HS256`: HMAC + SHA-256
- `RS256`: RSASSA-PKCS1-v1_5 + SHA-256
- `ES256`: ECDSA + P-256 + SHA-256

### Payload

페이로드는 사용자 데이터, 권한 등을 담는 JSON이다. 각 데이터를 클레임(claim)이라 부른다. 일부 클레임은 표준에서 특별한 용도로 쓰기 위하여 예약되어있다. 이를 registered claim이라고 부른다. 발행자를 표기하기 위한 `iss`, 유효기간을 표기하기 위한 `exp` 등이 이에 해당한다.

토큰에는 이를 base64로 인코딩한 값을 쓴다.

```elixir
payload = %{
  hey: "hello"
}

encoded_payload = payload
  |> Jason.encode!()
  |> Base.url_encode64(padding: false)
```

### Signature

시그니처는 인코딩한 header와 payload를 해싱한 후 header에서 정의한 방식으로 암호화 한 것이다. 

먼저 사용하는 JWA이 `ES256`이므로 ECDSA + P-256을 이용하여 비대칭키 쌍을 발급한다.

```bash
openssl ecparam -genkey -name secp256r1 -noout -out ec.key
openssl ec -in ec.key -pubout -out ec.pub
# priv: ec.key, pub: ec.pub
```

```elixir
privkey = File.read!("ec.key")
  |> :public_key.pem_decode() |> hd
  |> :public_key.pem_entry_decode()

encoded_header <> "." <> encoded_payload
  |> :public_key.sign(:sha256, privkey)
  |> Base.url_encode64(padding: false)
```

## 참고

- [RFC 7519 - JSON Web Token (JWT)](https://datatracker.ietf.org/doc/html/rfc7519)
- [JSON Web Token Introduction - jwt.io](https://jwt.io/introduction)