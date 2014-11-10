ComposedStream
==============

Provides take, and drop, both which accept a number of items to
take or drop, an array of streams to distribute the takes/drops from,
and a function which decides the next stream to use for each item that
is taken or dropped

```
ComposedStream.take(n, [stream, stream], next_stream_fn)
ComposedStream.drop(n, [stream, stream], next_stream_fn)
```

next\_stream\_fn receives a list of tuples where each tuple contains:

```
{stream, next_value_of_stream}
```

Your next\_stream\_fn should use the value to determine which stream
to return, and that stream will be used to drop the next value.

Drop returns an array of streams with the n dropped items distributed
among them as determined by the next\_stream\_fn

Take returns a plain list of values, taken from any of the list of streams
as determined by the next\_stream\_fn
