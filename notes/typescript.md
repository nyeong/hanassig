---
title: TypeScript
date: 2023-06-09
---

## private field

TypeScript는 `private`를 지원한다.

```typescript
class Animal {
  private name: string;

  public constructor(theName: string) {
    this.name = theName;
  }
}

const a = new Animal("Tokai Teio");
a.name;
//~~~~ Property 'name' is private and only accessible within class 'Animal'.
```

당연히 JavaScript로 트랜스컴파일해도 이게 구현될 줄 알았다.

1. 필드 이름에 prefix를 붙여서 이름을 바꿔버리거나.
2. Closure를 활용하거나.

의외로 아예 구현을 안 한다. JavaScript로 트랜스컴파일한 코드는 아래와 같다:

```javascript
class Animal {
  constructor(theName: string) {
    this.name = theName;
  }
}

const a = new Animal("Tokai Teio");
a.name // 접근 가능하다
```

그래서 그냥 `a.name`도 정상적으로 잘 접근할 수 있다. class가 도입되기 이전인 ES5라도 별반 다르지 않다. `this.name`으로 필드를 정의하기 때문에 충분히 외부에서 접근할 수 있다.

```javascript
var Animal = /** @class */ (function () {
    function Animal(theName) {
        this.name = theName;
    }
    return Animal;
}());
```

아래는 내가 생각해본 JavaScript에서 private field를 구현하는 방법들이다:

### 필드 이름 바꾸기

필드 이름을 바꾸면 언어적으로 private field를 지원하지 않더라도, 사용자로 하여금 접근을 못하게하거나, 접근하기 전에 한 번 더 생각하게 할 수 있다.

파이썬 역시 `private` 변수를 만들 수 없다. 다만 커뮤니티 규약으로, private으로 쓰고자하는 변수는 언더바(`_`)를 앞에 붙여서 정의한다.

```python
class Animal:
  def __init__(self, the_name):
    self._name = the_name

a = Animal("Tokai Teio")
a._name # 접근을 막을 수는 없어도, 적어도 접근자가 인지할 수는 있다
```

Go 언어는 독특하게도 파이썬처럼 규약을 통해서 private을 정의하는데, 실제로도 private로 동작한다. 아래의 예시의 `name` 처럼 소문자로 시작하는 필드는 private이다.

```go
type Animal struct {
  name string
}

func NewAnimal(theName string) *Animal {
  return &Animal {
    name: theName,
  }
}
```

prefix만 붙이는 것이 아니라 아예 필드 이름을 심볼로 만드는 것은 어떨까? 심볼은 항상 값이 다르기 때문에, 키로 사용한 심볼만 노출하지 않는다면 실제로 접근할 수 없을 것이다:

```javascript
const Animal = (function () {
	let _private_field_name = Symbol("name");
    function Animal(theName) {
        this[_private_field_name] = theName
    }
    Animal.prototype.getName = function () {
      return this[_private_field_name]
    }
    return Animal;
}());

const a = new Animal("Tokai Teio")
a.getName() // Tokai Teio
a.name // undefined

let _private_field_name = Symbol("name");
a[_private_field_name] // undefined
```

### closure를 이용한 구현

클로저(closure)를 이용하면 외부의 변수를 캡처할 수 있다. 이를 이용하면 private한 필드를 만들 수 있다.

```javascript
const Animal = (function() {
  let name = null;
  
  const Animal = function(theName) {
    name = theName;
  }
  Animal.prototype.getName = () => name;
  Animal.prototype.setName = (newName) => name = newName;
  return Animal;
})();

const a = new Animal("Tokai Teio")
a.getName() // "Tokai Teio"
a.name // undefined
a.setName("Special Weak")
a.getName() // "Special Weak"
```

이를 확장하여 내부에 별도의 key-value 자료구조를 저장하여 이를 private scope로 활용할 수도 있다.

```javascript
const Animal = (function () {
  let privateScope = new WeakMap();
  function Animal(theName) {
    privateScope.set(this, {
      name: theName
    })
  }
  Animal.prototype.getName = function () {
    return privateScope.get(this).name;
  }
  return Animal;
}());

const a = new Animal("Tokai Teio")
console.log(a.name)
console.log(a.getName())
```

### 참고

- [은닉을 향한 자바스크립트의 여정](https://ui.toast.com/weekly-pick/ko_20200312)
- [Private class features](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes/Private_class_fields)
