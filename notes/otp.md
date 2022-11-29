OTP; Open Telecom Platform. 옛날에는 전화 교환기, 스위치를 만드는 데에 쓰여서 이름이 저렇다.
얼랭, 엘릭서 생태계에서 거대한 시스템을 관리하기 위한 범용 도구이다.

엘릭서 프로그램을 개발할 때 [[elixir/프로세스]]를 직접 쓰기보다는 OTP에서 제공하는 도구를 쓰는 편이 낫다.

- Task: 작업을 백그라운드에서 하고 싶을 때 쓴다.
- Agent: 상태를 관리하고 싶을 때 쓴다.
- GenServer: 범용적인 상황에서 쓸 수 있는 만능 구현.

## Task

무언가를 백그라운드에서 돌리고 싶을 때 쓴다.

```elixir
iex> worker = Task.async(fn -> 오래_걸리는_작업() end)
iex> # do something else
iex> result = Task.await(worker)
```

익명 함수를 취하는 `Task.async/1`과 이름 있는 함수를 취하는 `Task.async/3`이 있다.

## Agent

상태를 관리하는 백그라운드 프로세스이다.

```elixir
iex> {:ok, count} = Agent.start(fn -> 2 end)
iex> Agent.get(count, &Function.identity/1)
2
iex> Agent.update(count, &(&1 * &1))
:ok
iex> Agent.get(count, &Function.identity/1)
4
```

## GenServer

여러 상황에 쓰일 수 있는 범용 서버이다.
`init/1`, `handle_call/3`, `handle_cast/2` 등의 콜백을 구현하여 사용한다.

### init

GenServer를 초기화한다.

```elixir
def init(start_args) do
  {:ok, state}
end
```

```elixir
iex> {:ok, server} = GenServer.start_link(MyServer, args)
```

### handle_call/3

`GenServer.call/3`을 통해 호출된 동기 메시지를 다룬다.

```elixir
def handle_call(request, _from, state) do
  {:reply, return, new_state}
end
```

인자는 `request, from, state` 꼴이다. `request`는 `call/3`에 의해 호출된 메시지를, `from`은 누가 호출했는지를,
`state`는 서버의 현재 상태를 나타낸다.

반환은 `{:reply, return, new_state}` 꼴이다. 반환값이 필요 없다면 `{:noreply, new_state}` 꼴로 반환하면 된다.

보통은 `request`를 튜플로 하여 인자를 함께 넘긴다.

```elixir
iex> GenServer.call(MyServer, {:call_name, call_args})
```

### handle_cast/2

`cast/2`를 통해 호출된 비동기 메시지를 다룬다.

인자는 `request, state` 꼴이다. `request`는 `cast/2`에 의해 호출된 메시지를,`state`는 서버의 현재 상태를 나타낸다.

```elixir
def handle_cast(request, state) do
  {:noreply, new_state}
end
```

아래와 같이 쓸 수 있다.

```elixir
iex> GenServer.cast(MyServer, {:call_name, call_args})
```

반환값이 필요 없다면 `{:noreply, new_state}` 꼴로 반환하면 된다.

### 구현 감싸기

```elixir
def start_link(start_args) do
  GenServer.start_link(__MODULE__, current_number, name: __MODULE__)
end
```