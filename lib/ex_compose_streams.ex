defmodule ComposedStream do

  def first_val(s) do
    Stream.take(s, 1) |> Enum.to_list |> List.first
  end

  def dummy_stream(start) do
    Stream.iterate(start, fn(x) -> x+2 end)
  end

  def min_stream(stream_heads) do
    Enum.sort(stream_heads, fn({_, x}, {_, y}) -> x < y end)
    |> List.first |> Tuple.to_list |> List.first
  end

  def enumerate_streams(streams, next_stream_fn, match_fn, no_match_fn) do
    stream_heads = Enum.map(streams, fn(s) -> {s, first_val(s)} end)
    next_stream = next_stream_fn.(stream_heads)
    Enum.map(streams, fn(s) ->
      if Stream.take(next_stream, 1) == Stream.take(s, 1) do
        match_fn.(s)
      else
        no_match_fn.(s)
      end
    end)
  end    

  def drop(1, streams, next_stream_fn) do
    enumerate_streams(streams, next_stream_fn, 
      &(Stream.drop(&1, 1)), &(&1))
  end

  def drop(n, streams, next_stream_fn) do
    case n do
      i when i > 1 ->
        drop(n-1, drop(1, streams, next_stream_fn), next_stream_fn)
      _ -> streams
    end
  end

  def take(1, streams, next_stream_fn) do
    enumerate_streams(streams, next_stream_fn,
      &(Stream.take(&1, 1) |> Enum.to_list), &(&1 && nil))
    |> Enum.drop_while(&(&1 == nil))
    |> List.first
  end

  def take(n, streams, next_stream_fn) do
    case n do
      i when i > 1 ->
        take(1, streams, next_stream_fn)
        |> Enum.concat(
          take(n-1, drop(1, streams, next_stream_fn), next_stream_fn))
      _ -> []
    end
  end
end
