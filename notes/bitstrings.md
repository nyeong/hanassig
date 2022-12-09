---
title: "bitstrings"
---
# bitstrings

[[elixir]]는 메모리의 비트열을 [bitstring]이라는 단위로 다룬다.

[bitstring]: https://elixir-lang.org/getting-started/binaries-strings-and-char-lists.html#bitstrings

## 기본 표기

`bitstring` 리터럴은 기본적으로 8비트, 즉 1바이트 단위로 값을 표기한다.

```elixir
iex> <<255>>
<<255>>
iex> <<256>>
0
```

그 외의 단위로 값을 표기하고 싶다면 `::size`를 붙여주면 된다.

```elixir
iex> <<4::8>>
<<4>>
iex> <<4::4>>
<<4::size(4)>>
iex> <<15::4>>
<<15::size(4)>>
iex> <<16::4>>
<<0::size(0)>>
```

패턴매칭도 된다.

```elixir
iex> <<a::1, b::1, c::1, d::1>> = <<4::4>>
<<4::size(4)>>
iex> [a, b, c, d]
[0, 1, 0, 0]
```

```elixir
iex> <<n::32>> = <<0, 255, 255, 255>>
<<0, 255, 255, 255>>
iex> n
16777215
```

```elixir
iex> <<255, 255, 255>> = <<0xFF, 0xFF, 0xFF>>
<<255, 255, 255>>
iex> Base.encode16(<<255, 255, 255>>)
"FFFFFF"
```

## 타입

- `<<>>`
- `binary()` = `<<_::_*8>>`
- `bitstring()` = `<<_::_*1>>`
