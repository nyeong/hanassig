---
title: 디자인 패턴
description:
date: 2023-02-24
tags:
---

## 의존성 주입

DI; Dependency Injection.

> really just a pretentious way to say 'taking an argument'[^1]

[^1]: https://www.youtube.com/watch?v=ZasXwtTRkio

- 내가 쓸 인터페이스부터 정의하고 (의존성), 나중에 구현체 끼어넣기 (주입).
- 구현체만 바꾸면 동작이 그대로라 좋다.

### 예시

```ts
class UserService {
  constructor(
    // userRepository는 여기서 의존성 주입한다.
    // 인스턴스 생성은 프레임워크에 맡긴다. (= IoC)
    @InjectRepository(User)
    private readonly userRepository: Repository<User>
  ) {}

  async create(body: BodyDto): Promise<ResponseDto> {
    // this.userRepository로 열심히 작업한다.
    // 나중에 Repository 종류가 바뀌면 (RDB에서 documented DB로 바뀐다던가) 인터페이스가 동일한 한 Repository만 새로 구현해서 DI하면 된다.
  }
}
```

### 의문

- UserController는 어차피 UserService에 의존하는데 (그렇게 설계했으니까) 이것마저 DI할 필요가 있을까?
- 모든 것들을 이것저것 DI하는데, 주입하는 대상을 바꾸었을 때 인터페이스가 바뀌는 상황이면 DI를 할 필요가 있을까?

### 참고

- Taehee Kim, [프런트엔드에서 의존성을 제어하는 법](https://twinstae.github.io/testing-with-dependency-injection/#%ED%95%A8%EC%88%98%ED%98%95%EC%97%90%EC%84%9C-%EC%9D%98%EC%A1%B4%EC%84%B1-%EC%A3%BC%EC%9E%85%EC%9D%84-%ED%95%98%EB%A9%B4-%EC%95%88-%EB%90%98%EB%8A%94-%EA%B1%B8%EA%B9%8C).
- Mark Seemann, [Dependency injection is passing an argument](https://blog.ploeh.dk/2017/01/27/dependency-injection-is-passing-an-argument/).
- Jin-Wook Chung, [DI는 IoC를 사용하지 않아도 된다](https://jwchung.github.io/DI%EB%8A%94-IoC%EB%A5%BC-%EC%82%AC%EC%9A%A9%ED%95%98%EC%A7%80-%EC%95%8A%EC%95%84%EB%8F%84-%EB%90%9C%EB%8B%A4).
- Rúnar Bjarnason, [Dead-Simple Dependency Injection](https://youtu.be/ZasXwtTRkio).
