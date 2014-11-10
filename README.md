ComposedStream
==============

Provides take, and drop, both which accept a number of items to
take or drop, an array of streams to distribute the takes/drops from,
and a function which decides the next stream to use for each item that
is taken or dropped

```
ComposedStream.take(n, [stream, stream], next\_stream\_fn)
ComposedStream.drop(n, [stream, stream], next\_stream\_fn)
```

next\_stream\_fn receives a list of tuples where each tuple contains:

```
{stream, next\_value\_of\_stream}
```

Your next\_stream\_fn should use the value to determine which stream
to return, and that stream will be used to drop the next value.

Function returns an array of streams with the n dropped items distributed
among them as determined by the next\_stream\_fn
