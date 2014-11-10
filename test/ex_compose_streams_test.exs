defmodule ComposedStreamTest do
  use ExUnit.Case
  alias ComposedStream, as: CS

  def streams do
    s1 = Stream.iterate(0, fn(x) -> x + 2 end)
    s2 = Stream.iterate(5, fn(x) -> x + 3 end)
    s3 = Stream.iterate(8, fn(x) -> x + 7 end)
    [s1, s2, s3]
  end

  test "drop/3 with min_stream/1 processes multiple streams low to high" do
    actual = CS.drop(5, streams, &CS.min_stream/1) 
      |> Enum.map(&(Stream.take(&1, 5) |> Enum.to_list))
    expected = [
      [8, 10, 12, 14, 16], 
      [8, 11, 14, 17, 20], 
      [8, 15, 22, 29, 36]
     ]
    assert actual == expected
  end

  test "take/3 with min_stream gives back items from streams low to high" do
    IO.inspect streams |> Enum.map(&(Stream.take(&1, 7) |> Enum.to_list))
    IO.inspect CS.take(10, streams, &CS.min_stream/1) #|> Enum.to_list
    expected = [0, 2, 4, 5, 6, 8, 8, 8, 10, 11]
    assert CS.take(10, streams, &CS.min_stream/1) == expected
  end
end
