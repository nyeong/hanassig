# dialyxir 적용하기

mix 프로젝트에서 `mix.exs`를 열고 `deps/0`에 다음을 추가한다.

```elixir
defp deps do
  [
    {:dialyxir, "~> 1.0", only: :dev, runtime: false}
  ]
end
```

이후 `mix dialyzer`로 타입 검사를 할 수 있다.

```bash
$ mix do deps.get, deps.compile
$ mix dialyzer
```