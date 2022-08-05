# 프로세스

## 생성

```elixir
@spec spawn(module, atom, list) :: pid
```

`module`과 `atom`은 실행할 함수를, `list`는 넘길 인자 리스트를 의미한다.
반환값인 `pid`는 프로세스 식별자이다.

```elixir
iex> spawn(SpawnBasic, :greet, [])
```


## 메시지 주고 받기

`send/2` 함수와 `receive` 매크로로 프로세스끼리 메시지를 주고 받을 수 있다.

### 보낼 때

`send/2` 함수를 이용하여 보낸다. 첫 인수는 `pid`, 메시지를 받을 프로세스이다.
두번째 인수는 `term()`으로 아무 값이나 보내도 되는데, 보통 `{:type, message}` 패턴을 많이 쓴다.

```elixir
iex> pid = spawn(Module, :function, [])
iex> send pid, {:ok, message}
```

### 받을 때

`receive` 매크로로 해당 프로세스에 도착한 메시지를 받아본다.
패턴매칭을 이용하여 메시지가 매칭되는 절을 실행한다.

```elixir
receive do
  {:ok, message} ->
    IO.puts message
end
```

`receive` 매크로는 기본적으로 메시지를 받을 때까지 블록된다. 이를 원치 않으면
`after` 절을 써서 타임아웃되도록 한다.

```elixir
receive do
  {:ok, message} ->
    IO.puts "do something with #{message}"
  after 500 ->
    IO.puts "timeout"
end
```

또한 기본적으로 한 번에 하나의 메시지만 처리하므로, 여러 메시지를 처리하기
원한다면 재귀를 써야 한다.

```elixir
def loop do
  receive do
    {:ok, message} ->
      IO.puts "do something with #{message}"
  end
  loop # 꼬리재귀 최적화된다
end
```

### 상태 전파

`Process.link/1` 함수로 현재 프로세스와 다른 프로세스를 링크할 수 있다.
`spawn_link` 함수를 쓰면 생성과 링크를 한 번에 할 수 있다.

``` elixir
iex> boom = fn ->
...>   :timer.sleep 500
...>   exit :boom
...> end
iex> spawn boom      # 아무 일도 일어나지 않는다
iex> spawn_link boom # spawn한 프로세스가 `exit` 되므로 현재 프로세스도 종료된다.
** (EXIT from #PID<0.105.0>) shell process exited with reason: :boom
```

`Process.monitor/1` 함수나 `spawn_monitor` 함수를 사용하면 단방향으로 프로세스를 연결할 수 있다.