#!/usr/bin/env elixir
defmodule Hana.Template do
  @spec render(String.t) :: String.t
  def render(filepath) do
    File.stream!(filepath)
    |> Stream.transform(nil, &reducer/2)
    |> Enum.to_list()
    |> Enum.join()
  end

  defp reducer(line = "[//begin]: # \"" <> rest, nil) do
    renderer = String.replace_suffix(rest, "\"\n", "")
    # TODO: check if the module is exists.
    module = Module.concat(Hana.Template, String.capitalize(renderer))
    {[line], module}
  end

  defp reducer("[//begin]: #" <> _, _) do
    throw("Nested blocks are not allowed")
  end

  defp reducer("[//end]: #" <> _, nil) do
    throw("End block encountered without a corresponding begin block")
  end

  defp reducer(line = "[//end]: #" <> _, renderer) do
    render_result = apply(renderer, :render, [])
    {[render_result, line], nil}
  end

  defp reducer(line, nil) do
    {[line], nil}
  end

  defp reducer(_, renderer) do
    # remove prev contents in the block
    {[], renderer}
  end
end

defmodule Hana.Template.Recent do
  # TODO: Get recent files in compile time.
  def render do
    # because the contents is list, you should use two new-line chars.
    get_recent()
    |> Enum.map(&to_md_list/1)
    |> Enum.join("\n")
    |> then(&(&1 <> "\n\n"))
  end

  defp to_md_list(filename) do
    filename
    |> String.replace_prefix("notes/", "- [[")
    |> String.replace_suffix(".md", "]]")
  end

  defp get_recent do
    {result, 0} = System.cmd("sh", ["bin/recent-notes.sh"])
    result
    |> String.split("\n")
    |> Enum.take(5) # TODO: get number as an argunemt.
    |> Enum.map(fn line ->
      String.split(line) |> List.last()
    end)
  end
end

~w{notes/index.md}
|> Enum.each(fn filepath ->
  # TODO: write when the content is changed only.
  new_content = filepath |> Hana.Template.render()

  File.write!(filepath, new_content)
  IO.puts("#{filepath} updated.")
end)
