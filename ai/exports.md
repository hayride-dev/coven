# <a id="exports"></a>World exports


 - Imports:
    - interface `hayride:ai/types@0.0.51`
    - interface `hayride:ai/context@0.0.51`
    - interface `wasi:nn/errors@0.2.0-rc-2024-10-28`
    - interface `wasi:nn/tensor@0.2.0-rc-2024-10-28`
    - interface `wasi:io/poll@0.2.0`
    - interface `wasi:io/error@0.2.0`
    - interface `wasi:io/streams@0.2.0`
    - interface `hayride:ai/tensor-stream@0.0.51`
    - interface `hayride:ai/inference-stream@0.0.51`
 - Exports:
    - interface `hayride:ai/model@0.0.51`
    - interface `hayride:ai/agents@0.0.51`

## <a id="hayride_ai_types_0_0_51"></a>Import interface hayride:ai/types@0.0.51


----

### Types

#### <a id="role"></a>`enum role`


##### Enum Cases

- <a id="role.user"></a>`user`
- <a id="role.assistant"></a>`assistant`
- <a id="role.system"></a>`system`
- <a id="role.tool"></a>`tool`
- <a id="role.unknown"></a>`unknown`
#### <a id="text_content"></a>`record text-content`


##### Record Fields

- <a id="text_content.text"></a>`text`: `string`
- <a id="text_content.content_type"></a>`content-type`: `string`
#### <a id="tool_schema"></a>`record tool-schema`


##### Record Fields

- <a id="tool_schema.id"></a>`id`: `string`
- <a id="tool_schema.name"></a>`name`: `string`
- <a id="tool_schema.description"></a>`description`: `string`
- <a id="tool_schema.params_schema"></a>`params-schema`: `string`
#### <a id="tool_input"></a>`record tool-input`


##### Record Fields

- <a id="tool_input.content_type"></a>`content-type`: `string`
- <a id="tool_input.id"></a>`id`: `string`
- <a id="tool_input.name"></a>`name`: `string`
- <a id="tool_input.input"></a>`input`: `string`
#### <a id="tool_output"></a>`record tool-output`


##### Record Fields

- <a id="tool_output.content_type"></a>`content-type`: `string`
- <a id="tool_output.id"></a>`id`: `string`
- <a id="tool_output.name"></a>`name`: `string`
- <a id="tool_output.output"></a>`output`: `string`
#### <a id="content"></a>`variant content`


##### Variant Cases

- <a id="content.none"></a>`none`
- <a id="content.text"></a>`text`: [`text-content`](#text_content)
- <a id="content.tool_schema"></a>`tool-schema`: [`tool-schema`](#tool_schema)
- <a id="content.tool_input"></a>`tool-input`: [`tool-input`](#tool_input)
- <a id="content.tool_output"></a>`tool-output`: [`tool-output`](#tool_output)
#### <a id="message"></a>`record message`


##### Record Fields

- <a id="message.role"></a>`role`: [`role`](#role)
- <a id="message.content"></a>`content`: list<[`content`](#content)>
## <a id="hayride_ai_context_0_0_51"></a>Import interface hayride:ai/context@0.0.51


----

### Types

#### <a id="message"></a>`type message`
[`message`](#message)
<p>
#### <a id="error_code"></a>`enum error-code`


##### Enum Cases

- <a id="error_code.unexpected_message_type"></a>`unexpected-message-type`
- <a id="error_code.push_error"></a>`push-error`
- <a id="error_code.message_not_found"></a>`message-not-found`
- <a id="error_code.unknown"></a>`unknown`
#### <a id="error"></a>`resource error`

#### <a id="context"></a>`resource context`

----

### Functions

#### <a id="method_error_code"></a>`[method]error.code: func`

return the error code.

##### Params

- <a id="method_error_code.self"></a>`self`: borrow<[`error`](#error)>

##### Return values

- <a id="method_error_code.0"></a> [`error-code`](#error_code)

#### <a id="method_error_data"></a>`[method]error.data: func`

errors can propagated with backend specific status through a string value.

##### Params

- <a id="method_error_data.self"></a>`self`: borrow<[`error`](#error)>

##### Return values

- <a id="method_error_data.0"></a> `string`

#### <a id="constructor_context"></a>`[constructor]context: func`


##### Return values

- <a id="constructor_context.0"></a> own<[`context`](#context)>

#### <a id="method_context_push"></a>`[method]context.push: func`


##### Params

- <a id="method_context_push.self"></a>`self`: borrow<[`context`](#context)>
- <a id="method_context_push.msg"></a>`msg`: [`message`](#message)

##### Return values

- <a id="method_context_push.0"></a> result<_, own<[`error`](#error)>>

#### <a id="method_context_messages"></a>`[method]context.messages: func`


##### Params

- <a id="method_context_messages.self"></a>`self`: borrow<[`context`](#context)>

##### Return values

- <a id="method_context_messages.0"></a> result<list<[`message`](#message)>, own<[`error`](#error)>>

## <a id="wasi_nn_errors_0_2_0_rc_2024_10_28"></a>Import interface wasi:nn/errors@0.2.0-rc-2024-10-28

TODO: create function-specific errors (https://github.com/WebAssembly/wasi-nn/issues/42)

----

### Types

#### <a id="error_code"></a>`enum error-code`


##### Enum Cases

- <a id="error_code.invalid_argument"></a>`invalid-argument`
  <p>Caller module passed an invalid argument.

- <a id="error_code.invalid_encoding"></a>`invalid-encoding`
  <p>Invalid encoding.

- <a id="error_code.timeout"></a>`timeout`
  <p>The operation timed out.

- <a id="error_code.runtime_error"></a>`runtime-error`
  <p>Runtime Error.

- <a id="error_code.unsupported_operation"></a>`unsupported-operation`
  <p>Unsupported operation.

- <a id="error_code.too_large"></a>`too-large`
  <p>Graph is too large.

- <a id="error_code.not_found"></a>`not-found`
  <p>Graph not found.

- <a id="error_code.security"></a>`security`
  <p>The operation is insecure or has insufficient privilege to be performed.
  e.g., cannot access a hardware feature requested

- <a id="error_code.unknown"></a>`unknown`
  <p>The operation failed for an unspecified reason.

#### <a id="error"></a>`resource error`

----

### Functions

#### <a id="method_error_code"></a>`[method]error.code: func`

Return the error code.

##### Params

- <a id="method_error_code.self"></a>`self`: borrow<[`error`](#error)>

##### Return values

- <a id="method_error_code.0"></a> [`error-code`](#error_code)

#### <a id="method_error_data"></a>`[method]error.data: func`

Errors can propagated with backend specific status through a string value.

##### Params

- <a id="method_error_data.self"></a>`self`: borrow<[`error`](#error)>

##### Return values

- <a id="method_error_data.0"></a> `string`

## <a id="wasi_nn_tensor_0_2_0_rc_2024_10_28"></a>Import interface wasi:nn/tensor@0.2.0-rc-2024-10-28

All inputs and outputs to an ML inference are represented as `tensor`s.

----

### Types

#### <a id="tensor_dimensions"></a>`type tensor-dimensions`
[`tensor-dimensions`](#tensor_dimensions)
<p>The dimensions of a tensor.

The array length matches the tensor rank and each element in the array describes the size of
each dimension

#### <a id="tensor_type"></a>`enum tensor-type`

The type of the elements in a tensor.

##### Enum Cases

- <a id="tensor_type.fp16"></a>`FP16`
- <a id="tensor_type.fp32"></a>`FP32`
- <a id="tensor_type.fp64"></a>`FP64`
- <a id="tensor_type.bf16"></a>`BF16`
- <a id="tensor_type.u8"></a>`U8`
- <a id="tensor_type.i32"></a>`I32`
- <a id="tensor_type.i64"></a>`I64`
#### <a id="tensor_data"></a>`type tensor-data`
[`tensor-data`](#tensor_data)
<p>The tensor data.

Initially conceived as a sparse representation, each empty cell would be filled with zeros
and the array length must match the product of all of the dimensions and the number of bytes
in the type (e.g., a 2x2 tensor with 4-byte f32 elements would have a data array of length
16). Naturally, this representation requires some knowledge of how to lay out data in
memory--e.g., using row-major ordering--and could perhaps be improved.

#### <a id="tensor"></a>`resource tensor`

----

### Functions

#### <a id="constructor_tensor"></a>`[constructor]tensor: func`


##### Params

- <a id="constructor_tensor.dimensions"></a>`dimensions`: [`tensor-dimensions`](#tensor_dimensions)
- <a id="constructor_tensor.ty"></a>`ty`: [`tensor-type`](#tensor_type)
- <a id="constructor_tensor.data"></a>`data`: [`tensor-data`](#tensor_data)

##### Return values

- <a id="constructor_tensor.0"></a> own<[`tensor`](#tensor)>

#### <a id="method_tensor_dimensions"></a>`[method]tensor.dimensions: func`

Describe the size of the tensor (e.g., 2x2x2x2 -> [2, 2, 2, 2]). To represent a tensor
containing a single value, use `[1]` for the tensor dimensions.

##### Params

- <a id="method_tensor_dimensions.self"></a>`self`: borrow<[`tensor`](#tensor)>

##### Return values

- <a id="method_tensor_dimensions.0"></a> [`tensor-dimensions`](#tensor_dimensions)

#### <a id="method_tensor_ty"></a>`[method]tensor.ty: func`

Describe the type of element in the tensor (e.g., `f32`).

##### Params

- <a id="method_tensor_ty.self"></a>`self`: borrow<[`tensor`](#tensor)>

##### Return values

- <a id="method_tensor_ty.0"></a> [`tensor-type`](#tensor_type)

#### <a id="method_tensor_data"></a>`[method]tensor.data: func`

Return the tensor data.

##### Params

- <a id="method_tensor_data.self"></a>`self`: borrow<[`tensor`](#tensor)>

##### Return values

- <a id="method_tensor_data.0"></a> [`tensor-data`](#tensor_data)

## <a id="wasi_io_poll_0_2_0"></a>Import interface wasi:io/poll@0.2.0

A poll API intended to let users wait for I/O events on multiple handles
at once.

----

### Types

#### <a id="pollable"></a>`resource pollable`

`pollable` represents a single I/O event which may be ready, or not.
----

### Functions

#### <a id="method_pollable_ready"></a>`[method]pollable.ready: func`

Return the readiness of a pollable. This function never blocks.

Returns `true` when the pollable is ready, and `false` otherwise.

##### Params

- <a id="method_pollable_ready.self"></a>`self`: borrow<[`pollable`](#pollable)>

##### Return values

- <a id="method_pollable_ready.0"></a> `bool`

#### <a id="method_pollable_block"></a>`[method]pollable.block: func`

`block` returns immediately if the pollable is ready, and otherwise
blocks until ready.

This function is equivalent to calling `poll.poll` on a list
containing only this pollable.

##### Params

- <a id="method_pollable_block.self"></a>`self`: borrow<[`pollable`](#pollable)>

#### <a id="poll"></a>`poll: func`

Poll for completion on a set of pollables.

This function takes a list of pollables, which identify I/O sources of
interest, and waits until one or more of the events is ready for I/O.

The result `list<u32>` contains one or more indices of handles in the
argument list that is ready for I/O.

If the list contains more elements than can be indexed with a `u32`
value, this function traps.

A timeout can be implemented by adding a pollable from the
wasi-clocks API to the list.

This function does not return a `result`; polling in itself does not
do any I/O so it doesn't fail. If any of the I/O sources identified by
the pollables has an error, it is indicated by marking the source as
being reaedy for I/O.

##### Params

- <a id="poll.in"></a>`in`: list<borrow<[`pollable`](#pollable)>>

##### Return values

- <a id="poll.0"></a> list<`u32`>

## <a id="wasi_io_error_0_2_0"></a>Import interface wasi:io/error@0.2.0


----

### Types

#### <a id="error"></a>`resource error`

A resource which represents some error information.

The only method provided by this resource is `to-debug-string`,
which provides some human-readable information about the error.

In the `wasi:io` package, this resource is returned through the
`wasi:io/streams/stream-error` type.

To provide more specific error information, other interfaces may
provide functions to further "downcast" this error into more specific
error information. For example, `error`s returned in streams derived
from filesystem types to be described using the filesystem's own
error-code type, using the function
`wasi:filesystem/types/filesystem-error-code`, which takes a parameter
`borrow<error>` and returns
`option<wasi:filesystem/types/error-code>`.

The set of functions which can "downcast" an `error` into a more
concrete type is open.
----

### Functions

#### <a id="method_error_to_debug_string"></a>`[method]error.to-debug-string: func`

Returns a string that is suitable to assist humans in debugging
this error.

WARNING: The returned string should not be consumed mechanically!
It may change across platforms, hosts, or other implementation
details. Parsing this string is a major platform-compatibility
hazard.

##### Params

- <a id="method_error_to_debug_string.self"></a>`self`: borrow<[`error`](#error)>

##### Return values

- <a id="method_error_to_debug_string.0"></a> `string`

## <a id="wasi_io_streams_0_2_0"></a>Import interface wasi:io/streams@0.2.0

WASI I/O is an I/O abstraction API which is currently focused on providing
stream types.

In the future, the component model is expected to add built-in stream types;
when it does, they are expected to subsume this API.

----

### Types

#### <a id="error"></a>`type error`
[`error`](#error)
<p>
#### <a id="pollable"></a>`type pollable`
[`pollable`](#pollable)
<p>
#### <a id="stream_error"></a>`variant stream-error`

An error for input-stream and output-stream operations.

##### Variant Cases

- <a id="stream_error.last_operation_failed"></a>`last-operation-failed`: own<[`error`](#error)>
  <p>The last operation (a write or flush) failed before completion.

  More information is available in the `error` payload.

- <a id="stream_error.closed"></a>`closed`
  <p>The stream is closed: no more input will be accepted by the
  stream. A closed output-stream will return this error on all
  future operations.

#### <a id="input_stream"></a>`resource input-stream`

An input bytestream.

`input-stream`s are *non-blocking* to the extent practical on underlying
platforms. I/O operations always return promptly; if fewer bytes are
promptly available than requested, they return the number of bytes promptly
available, which could even be zero. To wait for data to be available,
use the `subscribe` function to obtain a `pollable` which can be polled
for using `wasi:io/poll`.
#### <a id="output_stream"></a>`resource output-stream`

An output bytestream.

`output-stream`s are *non-blocking* to the extent practical on
underlying platforms. Except where specified otherwise, I/O operations also
always return promptly, after the number of bytes that can be written
promptly, which could even be zero. To wait for the stream to be ready to
accept data, the `subscribe` function to obtain a `pollable` which can be
polled for using `wasi:io/poll`.
----

### Functions

#### <a id="method_input_stream_read"></a>`[method]input-stream.read: func`

Perform a non-blocking read from the stream.

When the source of a `read` is binary data, the bytes from the source
are returned verbatim. When the source of a `read` is known to the
implementation to be text, bytes containing the UTF-8 encoding of the
text are returned.

This function returns a list of bytes containing the read data,
when successful. The returned list will contain up to `len` bytes;
it may return fewer than requested, but not more. The list is
empty when no bytes are available for reading at this time. The
pollable given by `subscribe` will be ready when more bytes are
available.

This function fails with a `stream-error` when the operation
encounters an error, giving `last-operation-failed`, or when the
stream is closed, giving `closed`.

When the caller gives a `len` of 0, it represents a request to
read 0 bytes. If the stream is still open, this call should
succeed and return an empty list, or otherwise fail with `closed`.

The `len` parameter is a `u64`, which could represent a list of u8 which
is not possible to allocate in wasm32, or not desirable to allocate as
as a return value by the callee. The callee may return a list of bytes
less than `len` in size while more bytes are available for reading.

##### Params

- <a id="method_input_stream_read.self"></a>`self`: borrow<[`input-stream`](#input_stream)>
- <a id="method_input_stream_read.len"></a>`len`: `u64`

##### Return values

- <a id="method_input_stream_read.0"></a> result<list<`u8`>, [`stream-error`](#stream_error)>

#### <a id="method_input_stream_blocking_read"></a>`[method]input-stream.blocking-read: func`

Read bytes from a stream, after blocking until at least one byte can
be read. Except for blocking, behavior is identical to `read`.

##### Params

- <a id="method_input_stream_blocking_read.self"></a>`self`: borrow<[`input-stream`](#input_stream)>
- <a id="method_input_stream_blocking_read.len"></a>`len`: `u64`

##### Return values

- <a id="method_input_stream_blocking_read.0"></a> result<list<`u8`>, [`stream-error`](#stream_error)>

#### <a id="method_input_stream_skip"></a>`[method]input-stream.skip: func`

Skip bytes from a stream. Returns number of bytes skipped.

Behaves identical to `read`, except instead of returning a list
of bytes, returns the number of bytes consumed from the stream.

##### Params

- <a id="method_input_stream_skip.self"></a>`self`: borrow<[`input-stream`](#input_stream)>
- <a id="method_input_stream_skip.len"></a>`len`: `u64`

##### Return values

- <a id="method_input_stream_skip.0"></a> result<`u64`, [`stream-error`](#stream_error)>

#### <a id="method_input_stream_blocking_skip"></a>`[method]input-stream.blocking-skip: func`

Skip bytes from a stream, after blocking until at least one byte
can be skipped. Except for blocking behavior, identical to `skip`.

##### Params

- <a id="method_input_stream_blocking_skip.self"></a>`self`: borrow<[`input-stream`](#input_stream)>
- <a id="method_input_stream_blocking_skip.len"></a>`len`: `u64`

##### Return values

- <a id="method_input_stream_blocking_skip.0"></a> result<`u64`, [`stream-error`](#stream_error)>

#### <a id="method_input_stream_subscribe"></a>`[method]input-stream.subscribe: func`

Create a `pollable` which will resolve once either the specified stream
has bytes available to read or the other end of the stream has been
closed.
The created `pollable` is a child resource of the `input-stream`.
Implementations may trap if the `input-stream` is dropped before
all derived `pollable`s created with this function are dropped.

##### Params

- <a id="method_input_stream_subscribe.self"></a>`self`: borrow<[`input-stream`](#input_stream)>

##### Return values

- <a id="method_input_stream_subscribe.0"></a> own<[`pollable`](#pollable)>

#### <a id="method_output_stream_check_write"></a>`[method]output-stream.check-write: func`

Check readiness for writing. This function never blocks.

Returns the number of bytes permitted for the next call to `write`,
or an error. Calling `write` with more bytes than this function has
permitted will trap.

When this function returns 0 bytes, the `subscribe` pollable will
become ready when this function will report at least 1 byte, or an
error.

##### Params

- <a id="method_output_stream_check_write.self"></a>`self`: borrow<[`output-stream`](#output_stream)>

##### Return values

- <a id="method_output_stream_check_write.0"></a> result<`u64`, [`stream-error`](#stream_error)>

#### <a id="method_output_stream_write"></a>`[method]output-stream.write: func`

Perform a write. This function never blocks.

When the destination of a `write` is binary data, the bytes from
`contents` are written verbatim. When the destination of a `write` is
known to the implementation to be text, the bytes of `contents` are
transcoded from UTF-8 into the encoding of the destination and then
written.

Precondition: check-write gave permit of Ok(n) and contents has a
length of less than or equal to n. Otherwise, this function will trap.

returns Err(closed) without writing if the stream has closed since
the last call to check-write provided a permit.

##### Params

- <a id="method_output_stream_write.self"></a>`self`: borrow<[`output-stream`](#output_stream)>
- <a id="method_output_stream_write.contents"></a>`contents`: list<`u8`>

##### Return values

- <a id="method_output_stream_write.0"></a> result<_, [`stream-error`](#stream_error)>

#### <a id="method_output_stream_blocking_write_and_flush"></a>`[method]output-stream.blocking-write-and-flush: func`

Perform a write of up to 4096 bytes, and then flush the stream. Block
until all of these operations are complete, or an error occurs.

This is a convenience wrapper around the use of `check-write`,
`subscribe`, `write`, and `flush`, and is implemented with the
following pseudo-code:

```text
let pollable = this.subscribe();
while !contents.is_empty() {
  // Wait for the stream to become writable
  pollable.block();
  let Ok(n) = this.check-write(); // eliding error handling
  let len = min(n, contents.len());
  let (chunk, rest) = contents.split_at(len);
  this.write(chunk  );            // eliding error handling
  contents = rest;
}
this.flush();
// Wait for completion of `flush`
pollable.block();
// Check for any errors that arose during `flush`
let _ = this.check-write();         // eliding error handling
```

##### Params

- <a id="method_output_stream_blocking_write_and_flush.self"></a>`self`: borrow<[`output-stream`](#output_stream)>
- <a id="method_output_stream_blocking_write_and_flush.contents"></a>`contents`: list<`u8`>

##### Return values

- <a id="method_output_stream_blocking_write_and_flush.0"></a> result<_, [`stream-error`](#stream_error)>

#### <a id="method_output_stream_flush"></a>`[method]output-stream.flush: func`

Request to flush buffered output. This function never blocks.

This tells the output-stream that the caller intends any buffered
output to be flushed. the output which is expected to be flushed
is all that has been passed to `write` prior to this call.

Upon calling this function, the `output-stream` will not accept any
writes (`check-write` will return `ok(0)`) until the flush has
completed. The `subscribe` pollable will become ready when the
flush has completed and the stream can accept more writes.

##### Params

- <a id="method_output_stream_flush.self"></a>`self`: borrow<[`output-stream`](#output_stream)>

##### Return values

- <a id="method_output_stream_flush.0"></a> result<_, [`stream-error`](#stream_error)>

#### <a id="method_output_stream_blocking_flush"></a>`[method]output-stream.blocking-flush: func`

Request to flush buffered output, and block until flush completes
and stream is ready for writing again.

##### Params

- <a id="method_output_stream_blocking_flush.self"></a>`self`: borrow<[`output-stream`](#output_stream)>

##### Return values

- <a id="method_output_stream_blocking_flush.0"></a> result<_, [`stream-error`](#stream_error)>

#### <a id="method_output_stream_subscribe"></a>`[method]output-stream.subscribe: func`

Create a `pollable` which will resolve once the output-stream
is ready for more writing, or an error has occured. When this
pollable is ready, `check-write` will return `ok(n)` with n>0, or an
error.

If the stream is closed, this pollable is always ready immediately.

The created `pollable` is a child resource of the `output-stream`.
Implementations may trap if the `output-stream` is dropped before
all derived `pollable`s created with this function are dropped.

##### Params

- <a id="method_output_stream_subscribe.self"></a>`self`: borrow<[`output-stream`](#output_stream)>

##### Return values

- <a id="method_output_stream_subscribe.0"></a> own<[`pollable`](#pollable)>

#### <a id="method_output_stream_write_zeroes"></a>`[method]output-stream.write-zeroes: func`

Write zeroes to a stream.

This should be used precisely like `write` with the exact same
preconditions (must use check-write first), but instead of
passing a list of bytes, you simply pass the number of zero-bytes
that should be written.

##### Params

- <a id="method_output_stream_write_zeroes.self"></a>`self`: borrow<[`output-stream`](#output_stream)>
- <a id="method_output_stream_write_zeroes.len"></a>`len`: `u64`

##### Return values

- <a id="method_output_stream_write_zeroes.0"></a> result<_, [`stream-error`](#stream_error)>

#### <a id="method_output_stream_blocking_write_zeroes_and_flush"></a>`[method]output-stream.blocking-write-zeroes-and-flush: func`

Perform a write of up to 4096 zeroes, and then flush the stream.
Block until all of these operations are complete, or an error
occurs.

This is a convenience wrapper around the use of `check-write`,
`subscribe`, `write-zeroes`, and `flush`, and is implemented with
the following pseudo-code:

```text
let pollable = this.subscribe();
while num_zeroes != 0 {
  // Wait for the stream to become writable
  pollable.block();
  let Ok(n) = this.check-write(); // eliding error handling
  let len = min(n, num_zeroes);
  this.write-zeroes(len);         // eliding error handling
  num_zeroes -= len;
}
this.flush();
// Wait for completion of `flush`
pollable.block();
// Check for any errors that arose during `flush`
let _ = this.check-write();         // eliding error handling
```

##### Params

- <a id="method_output_stream_blocking_write_zeroes_and_flush.self"></a>`self`: borrow<[`output-stream`](#output_stream)>
- <a id="method_output_stream_blocking_write_zeroes_and_flush.len"></a>`len`: `u64`

##### Return values

- <a id="method_output_stream_blocking_write_zeroes_and_flush.0"></a> result<_, [`stream-error`](#stream_error)>

#### <a id="method_output_stream_splice"></a>`[method]output-stream.splice: func`

Read from one stream and write to another.

The behavior of splice is equivelant to:
1. calling `check-write` on the `output-stream`
2. calling `read` on the `input-stream` with the smaller of the
`check-write` permitted length and the `len` provided to `splice`
3. calling `write` on the `output-stream` with that read data.

Any error reported by the call to `check-write`, `read`, or
`write` ends the splice and reports that error.

This function returns the number of bytes transferred; it may be less
than `len`.

##### Params

- <a id="method_output_stream_splice.self"></a>`self`: borrow<[`output-stream`](#output_stream)>
- <a id="method_output_stream_splice.src"></a>`src`: borrow<[`input-stream`](#input_stream)>
- <a id="method_output_stream_splice.len"></a>`len`: `u64`

##### Return values

- <a id="method_output_stream_splice.0"></a> result<`u64`, [`stream-error`](#stream_error)>

#### <a id="method_output_stream_blocking_splice"></a>`[method]output-stream.blocking-splice: func`

Read from one stream and write to another, with blocking.

This is similar to `splice`, except that it blocks until the
`output-stream` is ready for writing, and the `input-stream`
is ready for reading, before performing the `splice`.

##### Params

- <a id="method_output_stream_blocking_splice.self"></a>`self`: borrow<[`output-stream`](#output_stream)>
- <a id="method_output_stream_blocking_splice.src"></a>`src`: borrow<[`input-stream`](#input_stream)>
- <a id="method_output_stream_blocking_splice.len"></a>`len`: `u64`

##### Return values

- <a id="method_output_stream_blocking_splice.0"></a> result<`u64`, [`stream-error`](#stream_error)>

## <a id="hayride_ai_tensor_stream_0_0_51"></a>Import interface hayride:ai/tensor-stream@0.0.51

This interface defines a stream of tensors. The stream is a sequence of tensors.

----

### Types

#### <a id="tensor_data"></a>`type tensor-data`
[`tensor-data`](#tensor_data)
<p>
#### <a id="tensor_dimensions"></a>`type tensor-dimensions`
[`tensor-dimensions`](#tensor_dimensions)
<p>
#### <a id="tensor_type"></a>`type tensor-type`
[`tensor-type`](#tensor_type)
<p>
#### <a id="pollable"></a>`type pollable`
[`pollable`](#pollable)
<p>
#### <a id="stream_error"></a>`type stream-error`
[`stream-error`](#stream_error)
<p>
#### <a id="tensor_stream"></a>`resource tensor-stream`

----

### Functions

#### <a id="constructor_tensor_stream"></a>`[constructor]tensor-stream: func`


##### Params

- <a id="constructor_tensor_stream.dimensions"></a>`dimensions`: [`tensor-dimensions`](#tensor_dimensions)
- <a id="constructor_tensor_stream.ty"></a>`ty`: [`tensor-type`](#tensor_type)
- <a id="constructor_tensor_stream.data"></a>`data`: [`tensor-data`](#tensor_data)

##### Return values

- <a id="constructor_tensor_stream.0"></a> own<[`tensor-stream`](#tensor_stream)>

#### <a id="method_tensor_stream_dimensions"></a>`[method]tensor-stream.dimensions: func`

Describe the size of the tensor (e.g., 2x2x2x2 -> [2, 2, 2, 2]). To represent a tensor
containing a single value, use `[1]` for the tensor dimensions.

##### Params

- <a id="method_tensor_stream_dimensions.self"></a>`self`: borrow<[`tensor-stream`](#tensor_stream)>

##### Return values

- <a id="method_tensor_stream_dimensions.0"></a> [`tensor-dimensions`](#tensor_dimensions)

#### <a id="method_tensor_stream_ty"></a>`[method]tensor-stream.ty: func`

Describe the type of element in the tensor (e.g., `f32`).

##### Params

- <a id="method_tensor_stream_ty.self"></a>`self`: borrow<[`tensor-stream`](#tensor_stream)>

##### Return values

- <a id="method_tensor_stream_ty.0"></a> [`tensor-type`](#tensor_type)

#### <a id="method_tensor_stream_read"></a>`[method]tensor-stream.read: func`

Read up to `len` bytes from the stream.

##### Params

- <a id="method_tensor_stream_read.self"></a>`self`: borrow<[`tensor-stream`](#tensor_stream)>
- <a id="method_tensor_stream_read.len"></a>`len`: `u64`

##### Return values

- <a id="method_tensor_stream_read.0"></a> result<[`tensor-data`](#tensor_data), [`stream-error`](#stream_error)>

#### <a id="method_tensor_stream_subscribe"></a>`[method]tensor-stream.subscribe: func`


##### Params

- <a id="method_tensor_stream_subscribe.self"></a>`self`: borrow<[`tensor-stream`](#tensor_stream)>

##### Return values

- <a id="method_tensor_stream_subscribe.0"></a> own<[`pollable`](#pollable)>

## <a id="hayride_ai_inference_stream_0_0_51"></a>Import interface hayride:ai/inference-stream@0.0.51


----

### Types

#### <a id="error"></a>`type error`
[`error`](#error)
<p>
#### <a id="tensor"></a>`type tensor`
[`tensor`](#tensor)
<p>
#### <a id="tensor_stream"></a>`type tensor-stream`
[`tensor-stream`](#tensor_stream)
<p>
#### <a id="named_tensor"></a>`tuple named-tensor`

Identify a tensor by name; this is necessary to associate tensors to
graph inputs and outputs.

##### Tuple Fields

- <a id="named_tensor.0"></a>`0`: `string`
- <a id="named_tensor.1"></a>`1`: own<[`tensor`](#tensor)>
#### <a id="named_tensor_stream"></a>`tuple named-tensor-stream`


##### Tuple Fields

- <a id="named_tensor_stream.0"></a>`0`: `string`
- <a id="named_tensor_stream.1"></a>`1`: own<[`tensor-stream`](#tensor_stream)>
#### <a id="graph_execution_context_stream"></a>`resource graph-execution-context-stream`

----

### Functions

#### <a id="method_graph_execution_context_stream_compute"></a>`[method]graph-execution-context-stream.compute: func`

Compute the inference on the given inputs.

##### Params

- <a id="method_graph_execution_context_stream_compute.self"></a>`self`: borrow<[`graph-execution-context-stream`](#graph_execution_context_stream)>
- <a id="method_graph_execution_context_stream_compute.inputs"></a>`inputs`: list<[`named-tensor`](#named_tensor)>

##### Return values

- <a id="method_graph_execution_context_stream_compute.0"></a> result<[`named-tensor-stream`](#named_tensor_stream), own<[`error`](#error)>>

## <a id="hayride_ai_model_0_0_51"></a>Export interface hayride:ai/model@0.0.51

----

### Types

#### <a id="graph_execution_context_stream"></a>`type graph-execution-context-stream`
[`graph-execution-context-stream`](#graph_execution_context_stream)
<p>
#### <a id="message"></a>`type message`
[`message`](#message)
<p>
#### <a id="context"></a>`type context`
[`context`](#context)
<p>
#### <a id="error_code"></a>`enum error-code`


##### Enum Cases

- <a id="error_code.context_error"></a>`context-error`
- <a id="error_code.context_encode"></a>`context-encode`
- <a id="error_code.context_decode"></a>`context-decode`
- <a id="error_code.compute_error"></a>`compute-error`
- <a id="error_code.unknown"></a>`unknown`
#### <a id="error"></a>`resource error`

#### <a id="model"></a>`resource model`

----

### Functions

#### <a id="method_error_code"></a>`[method]error.code: func`

return the error code.

##### Params

- <a id="method_error_code.self"></a>`self`: borrow<[`error`](#error)>

##### Return values

- <a id="method_error_code.0"></a> [`error-code`](#error_code)

#### <a id="method_error_data"></a>`[method]error.data: func`

errors can propagated with backend specific status through a string value.

##### Params

- <a id="method_error_data.self"></a>`self`: borrow<[`error`](#error)>

##### Return values

- <a id="method_error_data.0"></a> `string`

#### <a id="constructor_model"></a>`[constructor]model: func`


##### Return values

- <a id="constructor_model.0"></a> own<[`model`](#model)>

#### <a id="method_model_compute"></a>`[method]model.compute: func`

todo: add options to compute so we can set model specific options

##### Params

- <a id="method_model_compute.self"></a>`self`: borrow<[`model`](#model)>
- <a id="method_model_compute.graph"></a>`graph`: own<[`graph-execution-context-stream`](#graph_execution_context_stream)>
- <a id="method_model_compute.messages"></a>`messages`: list<[`message`](#message)>

##### Return values

- <a id="method_model_compute.0"></a> result<[`message`](#message), own<[`error`](#error)>>

## <a id="hayride_ai_agents_0_0_51"></a>Export interface hayride:ai/agents@0.0.51

----

### Types

#### <a id="message"></a>`type message`
[`message`](#message)
<p>
#### <a id="tool_schema"></a>`type tool-schema`
[`tool-schema`](#tool_schema)
<p>
#### <a id="tool_input"></a>`type tool-input`
[`tool-input`](#tool_input)
<p>
#### <a id="tool_output"></a>`type tool-output`
[`tool-output`](#tool_output)
<p>
#### <a id="context"></a>`type context`
[`context`](#context)
<p>
#### <a id="model"></a>`type model`
[`model`](#model)
<p>
#### <a id="output_stream"></a>`type output-stream`
[`output-stream`](#output_stream)
<p>
#### <a id="error_code"></a>`enum error-code`


##### Enum Cases

- <a id="error_code.invoke_error"></a>`invoke-error`
- <a id="error_code.unknown"></a>`unknown`
#### <a id="error"></a>`resource error`

#### <a id="agent"></a>`resource agent`

----

### Functions

#### <a id="method_error_code"></a>`[method]error.code: func`

return the error code.

##### Params

- <a id="method_error_code.self"></a>`self`: borrow<[`error`](#error)>

##### Return values

- <a id="method_error_code.0"></a> [`error-code`](#error_code)

#### <a id="method_error_data"></a>`[method]error.data: func`

errors can propagated with backend specific status through a string value.

##### Params

- <a id="method_error_data.self"></a>`self`: borrow<[`error`](#error)>

##### Return values

- <a id="method_error_data.0"></a> `string`

#### <a id="constructor_agent"></a>`[constructor]agent: func`


##### Params

- <a id="constructor_agent.name"></a>`name`: `string`
- <a id="constructor_agent.instruction"></a>`instruction`: `string`
- <a id="constructor_agent.tools"></a>`tools`: list<[`tool-schema`](#tool_schema)>

##### Return values

- <a id="constructor_agent.0"></a> own<[`agent`](#agent)>

#### <a id="method_agent_context"></a>`[method]agent.context: func`


##### Params

- <a id="method_agent_context.self"></a>`self`: borrow<[`agent`](#agent)>

##### Return values

- <a id="method_agent_context.0"></a> result<list<[`message`](#message)>, own<[`error`](#error)>>

#### <a id="method_agent_tool_call"></a>`[method]agent.tool-call: func`


##### Params

- <a id="method_agent_tool_call.self"></a>`self`: borrow<[`agent`](#agent)>
- <a id="method_agent_tool_call.tool_input"></a>`tool-input`: [`tool-input`](#tool_input)

##### Return values

- <a id="method_agent_tool_call.0"></a> result<[`tool-output`](#tool_output), own<[`error`](#error)>>

#### <a id="invoke"></a>`invoke: func`


##### Params

- <a id="invoke.ctx"></a>`ctx`: own<[`context`](#context)>
- <a id="invoke.model"></a>`model`: own<[`model`](#model)>
- <a id="invoke.agent"></a>`agent`: own<[`agent`](#agent)>
- <a id="invoke.input"></a>`input`: list<[`message`](#message)>

##### Return values

- <a id="invoke.0"></a> result<[`message`](#message), own<[`error`](#error)>>

#### <a id="invoke_stream"></a>`invoke-stream: func`


##### Params

- <a id="invoke_stream.ctx"></a>`ctx`: own<[`context`](#context)>
- <a id="invoke_stream.model"></a>`model`: own<[`model`](#model)>
- <a id="invoke_stream.agent"></a>`agent`: own<[`agent`](#agent)>
- <a id="invoke_stream.input"></a>`input`: list<[`message`](#message)>
- <a id="invoke_stream.output"></a>`output`: own<[`output-stream`](#output_stream)>

##### Return values

- <a id="invoke_stream.0"></a> result<_, own<[`error`](#error)>>

