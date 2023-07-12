#!/usr/bin/env elixir
defmodule Lexer do
  defstruct buffer: "", tokens: []

  def tokenize(source) do
    next_token(source, %Lexer{}).tokens |> Enum.reverse()
  end

  def next_token("", context) do
    clear_buffer(context)
  end

  def next_token(source, context) do
    {source, context} = case source do
      "\n[//do]: # " <> rest ->
        read_dynamic_block(rest, context)
      
      "[[" <> rest ->
        read_inner_link(rest, context)
        
      _ ->
        {ch, rest} = String.next_grapheme(source)
        {rest, add_buffer(context, ch)}
    end

    next_token(source, context)
  end

  def read_dynamic_block(source, context) do
    pattern = ~r/^"([a-z\-]+)".*/
    case Regex.run(pattern, source) do
      [_, template_name | _] ->
        token = {:dynamic_block, template_name}
        {skip_until_end(source), add_token(context, token)}
    _ ->
      {source, add_buffer(context, "\n")}
    end
  end

  def skip_until_end(source)
  def skip_until_end("\n[//end]:" <> rest) do
    [_, rest | _] = String.split(rest, "\n", parts: 2)
    rest
  end
  def skip_until_end(<<_::utf8, rest::binary>>) do
    skip_until_end(rest)
  end

  def read_inner_link(source, context) do
    pattern = ~r/^([a-z\-]+)\]\]/
    case Regex.run(pattern, source) do
      [whole, link_id] ->
        token = {:inner_link, link_id}
        {skip_source(source, whole), add_token(context, token)}

      _ ->
        {source, add_buffer(context, "[[")}
    end
  end

  def clear_buffer(%Lexer{buffer: ""} = lexer) do
    lexer
  end

  def clear_buffer(%Lexer{buffer: buffer} = lexer) do
    token = {:raw, buffer}
    add_token(%Lexer{lexer | buffer: ""}, token)
  end


  def add_buffer(lexer, ch) do
    %Lexer{lexer | buffer: lexer.buffer <> ch}
  end

  def skip_source(source, pattern) when is_binary(pattern) do
    String.slice(source, String.length(pattern)..-1)
  end

  def skip_source(source, length) do
    String.slice(source, length..-1)
  end

  def add_token(lexer, token) do
    lexer = clear_buffer(lexer)
    %Lexer{lexer | tokens: [token | lexer.tokens]}
  end
end

defmodule Parser do
  defstruct tokens: [], inner_links: %{}

  def parse(tokens) do
    Enum.reduce(tokens, %Parser{}, &parse_token/2)
    |> Map.update!(:tokens, &Enum.reverse/1)
  end

  def parse_token({:dynamic_block, "inner-links"}, parser) do
    parser
  end

  def parse_token({:dynamic_block, "recent"}, parser) do
    recent = System.cmd("sh", ["-c", "bin/recent-notes.sh"])
    |> elem(0)
    |> String.trim_trailing()
    |> String.split("\n")
    |> Enum.map(fn row ->
      full_path = String.slice(row, 26..-1)
      link_id = String.slice(full_path, 6..-4)
      {link_id, full_path}
    end)

    token = {:recent, recent}

    %Parser{parser|
      tokens: [token | parser.tokens],
      inner_links: Map.merge(Map.new(recent), parser.inner_links)
    }
  end

  def parse_token({:inner_link, link_id} = token, parser) do
    path = "notes/#{link_id}.md"
    case {File.exists?(path), String.starts_with?(link_id, "#")} do
      {true, _} ->
        %Parser{parser |
          tokens: [token | parser.tokens],
          inner_links: Map.put(parser.inner_links, link_id, path)
        }
      {false, true} ->
        %Parser{parser |
          tokens: [token | parser.tokens],
          inner_links: Map.put(parser.inner_links, link_id, link_id)
        }

      _ -> raise "Error on parsing inner_link #{link_id}"
    end
  end

  def parse_token({:raw, _} = token, parser) do
    %Parser{parser | tokens: [token | parser.tokens]}
  end

  def parse_token(token, parser) do
    raise "unexpected token, #{token} with #{parser}"
  end

  def parse_inner_links(links) do
    for link <- links, into: %{} do
      full_path = "notes/" <> link <> ".md"
      if File.exists?(full_path) do
        {link, full_path}
      else
        raise "#{full_path} does not exist. (#{link})"
      end
    end
  end
end

defmodule Renderer do
  def render(%Parser{} = parser) do
    rendered_tokens = Enum.reduce(parser.tokens, "", &render_tokens/2)
    rendered_tokens
    |> String.trim_trailing()
    |> then(&(&1 <> "\n" <> render_inner_links(parser.inner_links)))
  end

  def render_inner_links(inner_links) do
    if Enum.empty?(inner_links) do
      ""
    else
      Enum.map(inner_links, fn {id, path} -> "[#{id}]: #{String.slice(path, 6..-1)}" end)
      |> Enum.join("\n")
      |> render_dynamic_block("inner-links")
    end
  end

  def render_tokens({:raw, str}, acc) do
    acc <> str
  end

  def render_tokens({:recent, recent}, acc) do
    str = Enum.map(recent, fn {id, _} -> "- [[#{id}]]" end) |> Enum.join("\n")
    |> render_dynamic_block("recent")
    acc <> str
  end

  def render_tokens({:inner_link, link_id}, acc) do
    str = "[[#{link_id}]]"
    acc <> str
  end

  def render_dynamic_block(content, name) do
    now = NaiveDateTime.utc_now() |> Calendar.strftime("%Y-%m-%d %H:%M")
    ~s(\n[//do]: # "#{name}"\n\n)
    <> content
    <> ~s(\n\n[//end]: # "#{now}"\n)
  end
end

File.ls!("notes")
|> Enum.map(fn note_name ->
  if String.ends_with?(note_name, ".md") do
    file_path = "notes/" <> note_name
    content = File.read!(file_path)
    |> Lexer.tokenize()
    |> Parser.parse()
    |> Renderer.render()

    File.write!(file_path, content)
  end
end)
