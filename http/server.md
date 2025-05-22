# <a id="server"></a>World server


 - Imports:
    - interface `wasi:io/poll@0.2.0`
    - interface `wasi:clocks/monotonic-clock@0.2.0`
    - interface `wasi:io/error@0.2.0`
    - interface `wasi:io/streams@0.2.0`
    - interface `wasi:http/types@0.2.0`
 - Exports:
    - interface `wasi:http/incoming-handler@0.2.0`
    - interface `hayride:http/config@0.0.50`

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

## <a id="wasi_clocks_monotonic_clock_0_2_0"></a>Import interface wasi:clocks/monotonic-clock@0.2.0

WASI Monotonic Clock is a clock API intended to let users measure elapsed
time.

It is intended to be portable at least between Unix-family platforms and
Windows.

A monotonic clock is a clock which has an unspecified initial value, and
successive reads of the clock will produce non-decreasing values.

It is intended for measuring elapsed time.

----

### Types

#### <a id="pollable"></a>`type pollable`
[`pollable`](#pollable)
<p>
#### <a id="instant"></a>`type instant`
`u64`
<p>An instant in time, in nanoseconds. An instant is relative to an
unspecified initial value, and can only be compared to instances from
the same monotonic-clock.

#### <a id="duration"></a>`type duration`
`u64`
<p>A duration of time, in nanoseconds.

----

### Functions

#### <a id="now"></a>`now: func`

Read the current value of the clock.

The clock is monotonic, therefore calling this function repeatedly will
produce a sequence of non-decreasing values.

##### Return values

- <a id="now.0"></a> [`instant`](#instant)

#### <a id="resolution"></a>`resolution: func`

Query the resolution of the clock. Returns the duration of time
corresponding to a clock tick.

##### Return values

- <a id="resolution.0"></a> [`duration`](#duration)

#### <a id="subscribe_instant"></a>`subscribe-instant: func`

Create a `pollable` which will resolve once the specified instant
occured.

##### Params

- <a id="subscribe_instant.when"></a>`when`: [`instant`](#instant)

##### Return values

- <a id="subscribe_instant.0"></a> own<[`pollable`](#pollable)>

#### <a id="subscribe_duration"></a>`subscribe-duration: func`

Create a `pollable` which will resolve once the given duration has
elapsed, starting at the time at which this function was called.
occured.

##### Params

- <a id="subscribe_duration.when"></a>`when`: [`duration`](#duration)

##### Return values

- <a id="subscribe_duration.0"></a> own<[`pollable`](#pollable)>

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

## <a id="wasi_http_types_0_2_0"></a>Import interface wasi:http/types@0.2.0

This interface defines all of the types and methods for implementing
HTTP Requests and Responses, both incoming and outgoing, as well as
their headers, trailers, and bodies.

----

### Types

#### <a id="duration"></a>`type duration`
[`duration`](#duration)
<p>
#### <a id="input_stream"></a>`type input-stream`
[`input-stream`](#input_stream)
<p>
#### <a id="output_stream"></a>`type output-stream`
[`output-stream`](#output_stream)
<p>
#### <a id="io_error"></a>`type io-error`
[`error`](#error)
<p>
#### <a id="pollable"></a>`type pollable`
[`pollable`](#pollable)
<p>
#### <a id="method"></a>`variant method`

This type corresponds to HTTP standard Methods.

##### Variant Cases

- <a id="method.get"></a>`get`
- <a id="method.head"></a>`head`
- <a id="method.post"></a>`post`
- <a id="method.put"></a>`put`
- <a id="method.delete"></a>`delete`
- <a id="method.connect"></a>`connect`
- <a id="method.options"></a>`options`
- <a id="method.trace"></a>`trace`
- <a id="method.patch"></a>`patch`
- <a id="method.other"></a>`other`: `string`
#### <a id="scheme"></a>`variant scheme`

This type corresponds to HTTP standard Related Schemes.

##### Variant Cases

- <a id="scheme.http"></a>`HTTP`
- <a id="scheme.https"></a>`HTTPS`
- <a id="scheme.other"></a>`other`: `string`
#### <a id="dns_error_payload"></a>`record DNS-error-payload`

Defines the case payload type for `DNS-error` above:

##### Record Fields

- <a id="dns_error_payload.rcode"></a>`rcode`: option<`string`>
- <a id="dns_error_payload.info_code"></a>`info-code`: option<`u16`>
#### <a id="tls_alert_received_payload"></a>`record TLS-alert-received-payload`

Defines the case payload type for `TLS-alert-received` above:

##### Record Fields

- <a id="tls_alert_received_payload.alert_id"></a>`alert-id`: option<`u8`>
- <a id="tls_alert_received_payload.alert_message"></a>`alert-message`: option<`string`>
#### <a id="field_size_payload"></a>`record field-size-payload`

Defines the case payload type for `HTTP-response-{header,trailer}-size` above:

##### Record Fields

- <a id="field_size_payload.field_name"></a>`field-name`: option<`string`>
- <a id="field_size_payload.field_size"></a>`field-size`: option<`u32`>
#### <a id="error_code"></a>`variant error-code`

These cases are inspired by the IANA HTTP Proxy Error Types:
https://www.iana.org/assignments/http-proxy-status/http-proxy-status.xhtml#table-http-proxy-error-types

##### Variant Cases

- <a id="error_code.dns_timeout"></a>`DNS-timeout`
- <a id="error_code.dns_error"></a>`DNS-error`: [`DNS-error-payload`](#dns_error_payload)
- <a id="error_code.destination_not_found"></a>`destination-not-found`
- <a id="error_code.destination_unavailable"></a>`destination-unavailable`
- <a id="error_code.destination_ip_prohibited"></a>`destination-IP-prohibited`
- <a id="error_code.destination_ip_unroutable"></a>`destination-IP-unroutable`
- <a id="error_code.connection_refused"></a>`connection-refused`
- <a id="error_code.connection_terminated"></a>`connection-terminated`
- <a id="error_code.connection_timeout"></a>`connection-timeout`
- <a id="error_code.connection_read_timeout"></a>`connection-read-timeout`
- <a id="error_code.connection_write_timeout"></a>`connection-write-timeout`
- <a id="error_code.connection_limit_reached"></a>`connection-limit-reached`
- <a id="error_code.tls_protocol_error"></a>`TLS-protocol-error`
- <a id="error_code.tls_certificate_error"></a>`TLS-certificate-error`
- <a id="error_code.tls_alert_received"></a>`TLS-alert-received`: [`TLS-alert-received-payload`](#tls_alert_received_payload)
- <a id="error_code.http_request_denied"></a>`HTTP-request-denied`
- <a id="error_code.http_request_length_required"></a>`HTTP-request-length-required`
- <a id="error_code.http_request_body_size"></a>`HTTP-request-body-size`: option<`u64`>
- <a id="error_code.http_request_method_invalid"></a>`HTTP-request-method-invalid`
- <a id="error_code.http_request_uri_invalid"></a>`HTTP-request-URI-invalid`
- <a id="error_code.http_request_uri_too_long"></a>`HTTP-request-URI-too-long`
- <a id="error_code.http_request_header_section_size"></a>`HTTP-request-header-section-size`: option<`u32`>
- <a id="error_code.http_request_header_size"></a>`HTTP-request-header-size`: option<[`field-size-payload`](#field_size_payload)>
- <a id="error_code.http_request_trailer_section_size"></a>`HTTP-request-trailer-section-size`: option<`u32`>
- <a id="error_code.http_request_trailer_size"></a>`HTTP-request-trailer-size`: [`field-size-payload`](#field_size_payload)
- <a id="error_code.http_response_incomplete"></a>`HTTP-response-incomplete`
- <a id="error_code.http_response_header_section_size"></a>`HTTP-response-header-section-size`: option<`u32`>
- <a id="error_code.http_response_header_size"></a>`HTTP-response-header-size`: [`field-size-payload`](#field_size_payload)
- <a id="error_code.http_response_body_size"></a>`HTTP-response-body-size`: option<`u64`>
- <a id="error_code.http_response_trailer_section_size"></a>`HTTP-response-trailer-section-size`: option<`u32`>
- <a id="error_code.http_response_trailer_size"></a>`HTTP-response-trailer-size`: [`field-size-payload`](#field_size_payload)
- <a id="error_code.http_response_transfer_coding"></a>`HTTP-response-transfer-coding`: option<`string`>
- <a id="error_code.http_response_content_coding"></a>`HTTP-response-content-coding`: option<`string`>
- <a id="error_code.http_response_timeout"></a>`HTTP-response-timeout`
- <a id="error_code.http_upgrade_failed"></a>`HTTP-upgrade-failed`
- <a id="error_code.http_protocol_error"></a>`HTTP-protocol-error`
- <a id="error_code.loop_detected"></a>`loop-detected`
- <a id="error_code.configuration_error"></a>`configuration-error`
- <a id="error_code.internal_error"></a>`internal-error`: option<`string`>
  <p>This is a catch-all error for anything that doesn't fit cleanly into a
  more specific case. It also includes an optional string for an
  unstructured description of the error. Users should not depend on the
  string for diagnosing errors, as it's not required to be consistent
  between implementations.

#### <a id="header_error"></a>`variant header-error`

This type enumerates the different kinds of errors that may occur when
setting or appending to a `fields` resource.

##### Variant Cases

- <a id="header_error.invalid_syntax"></a>`invalid-syntax`
  <p>This error indicates that a `field-key` or `field-value` was
  syntactically invalid when used with an operation that sets headers in a
  `fields`.

- <a id="header_error.forbidden"></a>`forbidden`
  <p>This error indicates that a forbidden `field-key` was used when trying
  to set a header in a `fields`.

- <a id="header_error.immutable"></a>`immutable`
  <p>This error indicates that the operation on the `fields` was not
  permitted because the fields are immutable.

#### <a id="field_key"></a>`type field-key`
`string`
<p>Field keys are always strings.

#### <a id="field_value"></a>`type field-value`
[`field-value`](#field_value)
<p>Field values should always be ASCII strings. However, in
reality, HTTP implementations often have to interpret malformed values,
so they are provided as a list of bytes.

#### <a id="fields"></a>`resource fields`

This following block defines the `fields` resource which corresponds to
HTTP standard Fields. Fields are a common representation used for both
Headers and Trailers.

A `fields` may be mutable or immutable. A `fields` created using the
constructor, `from-list`, or `clone` will be mutable, but a `fields`
resource given by other means (including, but not limited to,
`incoming-request.headers`, `outgoing-request.headers`) might be be
immutable. In an immutable fields, the `set`, `append`, and `delete`
operations will fail with `header-error.immutable`.
#### <a id="headers"></a>`type headers`
[`fields`](#fields)
<p>Headers is an alias for Fields.

#### <a id="trailers"></a>`type trailers`
[`fields`](#fields)
<p>Trailers is an alias for Fields.

#### <a id="incoming_request"></a>`resource incoming-request`

Represents an incoming HTTP Request.
#### <a id="outgoing_request"></a>`resource outgoing-request`

Represents an outgoing HTTP Request.
#### <a id="request_options"></a>`resource request-options`

Parameters for making an HTTP Request. Each of these parameters is
currently an optional timeout applicable to the transport layer of the
HTTP protocol.

These timeouts are separate from any the user may use to bound a
blocking call to `wasi:io/poll.poll`.
#### <a id="response_outparam"></a>`resource response-outparam`

Represents the ability to send an HTTP Response.

This resource is used by the `wasi:http/incoming-handler` interface to
allow a Response to be sent corresponding to the Request provided as the
other argument to `incoming-handler.handle`.
#### <a id="status_code"></a>`type status-code`
`u16`
<p>This type corresponds to the HTTP standard Status Code.

#### <a id="incoming_response"></a>`resource incoming-response`

Represents an incoming HTTP Response.
#### <a id="incoming_body"></a>`resource incoming-body`

Represents an incoming HTTP Request or Response's Body.

A body has both its contents - a stream of bytes - and a (possibly
empty) set of trailers, indicating that the full contents of the
body have been received. This resource represents the contents as
an `input-stream` and the delivery of trailers as a `future-trailers`,
and ensures that the user of this interface may only be consuming either
the body contents or waiting on trailers at any given time.
#### <a id="future_trailers"></a>`resource future-trailers`

Represents a future which may eventaully return trailers, or an error.

In the case that the incoming HTTP Request or Response did not have any
trailers, this future will resolve to the empty set of trailers once the
complete Request or Response body has been received.
#### <a id="outgoing_response"></a>`resource outgoing-response`

Represents an outgoing HTTP Response.
#### <a id="outgoing_body"></a>`resource outgoing-body`

Represents an outgoing HTTP Request or Response's Body.

A body has both its contents - a stream of bytes - and a (possibly
empty) set of trailers, inducating the full contents of the body
have been sent. This resource represents the contents as an
`output-stream` child resource, and the completion of the body (with
optional trailers) with a static function that consumes the
`outgoing-body` resource, and ensures that the user of this interface
may not write to the body contents after the body has been finished.

If the user code drops this resource, as opposed to calling the static
method `finish`, the implementation should treat the body as incomplete,
and that an error has occured. The implementation should propogate this
error to the HTTP protocol by whatever means it has available,
including: corrupting the body on the wire, aborting the associated
Request, or sending a late status code for the Response.
#### <a id="future_incoming_response"></a>`resource future-incoming-response`

Represents a future which may eventaully return an incoming HTTP
Response, or an error.

This resource is returned by the `wasi:http/outgoing-handler` interface to
provide the HTTP Response corresponding to the sent Request.
----

### Functions

#### <a id="http_error_code"></a>`http-error-code: func`

Attempts to extract a http-related `error` from the wasi:io `error`
provided.

Stream operations which return
`wasi:io/stream/stream-error::last-operation-failed` have a payload of
type `wasi:io/error/error` with more information about the operation
that failed. This payload can be passed through to this function to see
if there's http-related information about the error to return.

Note that this function is fallible because not all io-errors are
http-related errors.

##### Params

- <a id="http_error_code.err"></a>`err`: borrow<[`io-error`](#io_error)>

##### Return values

- <a id="http_error_code.0"></a> option<[`error-code`](#error_code)>

#### <a id="constructor_fields"></a>`[constructor]fields: func`

Construct an empty HTTP Fields.

The resulting `fields` is mutable.

##### Return values

- <a id="constructor_fields.0"></a> own<[`fields`](#fields)>

#### <a id="static_fields_from_list"></a>`[static]fields.from-list: func`

Construct an HTTP Fields.

The resulting `fields` is mutable.

The list represents each key-value pair in the Fields. Keys
which have multiple values are represented by multiple entries in this
list with the same key.

The tuple is a pair of the field key, represented as a string, and
Value, represented as a list of bytes. In a valid Fields, all keys
and values are valid UTF-8 strings. However, values are not always
well-formed, so they are represented as a raw list of bytes.

An error result will be returned if any header or value was
syntactically invalid, or if a header was forbidden.

##### Params

- <a id="static_fields_from_list.entries"></a>`entries`: list<([`field-key`](#field_key), [`field-value`](#field_value))>

##### Return values

- <a id="static_fields_from_list.0"></a> result<own<[`fields`](#fields)>, [`header-error`](#header_error)>

#### <a id="method_fields_get"></a>`[method]fields.get: func`

Get all of the values corresponding to a key. If the key is not present
in this `fields`, an empty list is returned. However, if the key is
present but empty, this is represented by a list with one or more
empty field-values present.

##### Params

- <a id="method_fields_get.self"></a>`self`: borrow<[`fields`](#fields)>
- <a id="method_fields_get.name"></a>`name`: [`field-key`](#field_key)

##### Return values

- <a id="method_fields_get.0"></a> list<[`field-value`](#field_value)>

#### <a id="method_fields_has"></a>`[method]fields.has: func`

Returns `true` when the key is present in this `fields`. If the key is
syntactically invalid, `false` is returned.

##### Params

- <a id="method_fields_has.self"></a>`self`: borrow<[`fields`](#fields)>
- <a id="method_fields_has.name"></a>`name`: [`field-key`](#field_key)

##### Return values

- <a id="method_fields_has.0"></a> `bool`

#### <a id="method_fields_set"></a>`[method]fields.set: func`

Set all of the values for a key. Clears any existing values for that
key, if they have been set.

Fails with `header-error.immutable` if the `fields` are immutable.

##### Params

- <a id="method_fields_set.self"></a>`self`: borrow<[`fields`](#fields)>
- <a id="method_fields_set.name"></a>`name`: [`field-key`](#field_key)
- <a id="method_fields_set.value"></a>`value`: list<[`field-value`](#field_value)>

##### Return values

- <a id="method_fields_set.0"></a> result<_, [`header-error`](#header_error)>

#### <a id="method_fields_delete"></a>`[method]fields.delete: func`

Delete all values for a key. Does nothing if no values for the key
exist.

Fails with `header-error.immutable` if the `fields` are immutable.

##### Params

- <a id="method_fields_delete.self"></a>`self`: borrow<[`fields`](#fields)>
- <a id="method_fields_delete.name"></a>`name`: [`field-key`](#field_key)

##### Return values

- <a id="method_fields_delete.0"></a> result<_, [`header-error`](#header_error)>

#### <a id="method_fields_append"></a>`[method]fields.append: func`

Append a value for a key. Does not change or delete any existing
values for that key.

Fails with `header-error.immutable` if the `fields` are immutable.

##### Params

- <a id="method_fields_append.self"></a>`self`: borrow<[`fields`](#fields)>
- <a id="method_fields_append.name"></a>`name`: [`field-key`](#field_key)
- <a id="method_fields_append.value"></a>`value`: [`field-value`](#field_value)

##### Return values

- <a id="method_fields_append.0"></a> result<_, [`header-error`](#header_error)>

#### <a id="method_fields_entries"></a>`[method]fields.entries: func`

Retrieve the full set of keys and values in the Fields. Like the
constructor, the list represents each key-value pair.

The outer list represents each key-value pair in the Fields. Keys
which have multiple values are represented by multiple entries in this
list with the same key.

##### Params

- <a id="method_fields_entries.self"></a>`self`: borrow<[`fields`](#fields)>

##### Return values

- <a id="method_fields_entries.0"></a> list<([`field-key`](#field_key), [`field-value`](#field_value))>

#### <a id="method_fields_clone"></a>`[method]fields.clone: func`

Make a deep copy of the Fields. Equivelant in behavior to calling the
`fields` constructor on the return value of `entries`. The resulting
`fields` is mutable.

##### Params

- <a id="method_fields_clone.self"></a>`self`: borrow<[`fields`](#fields)>

##### Return values

- <a id="method_fields_clone.0"></a> own<[`fields`](#fields)>

#### <a id="method_incoming_request_method"></a>`[method]incoming-request.method: func`

Returns the method of the incoming request.

##### Params

- <a id="method_incoming_request_method.self"></a>`self`: borrow<[`incoming-request`](#incoming_request)>

##### Return values

- <a id="method_incoming_request_method.0"></a> [`method`](#method)

#### <a id="method_incoming_request_path_with_query"></a>`[method]incoming-request.path-with-query: func`

Returns the path with query parameters from the request, as a string.

##### Params

- <a id="method_incoming_request_path_with_query.self"></a>`self`: borrow<[`incoming-request`](#incoming_request)>

##### Return values

- <a id="method_incoming_request_path_with_query.0"></a> option<`string`>

#### <a id="method_incoming_request_scheme"></a>`[method]incoming-request.scheme: func`

Returns the protocol scheme from the request.

##### Params

- <a id="method_incoming_request_scheme.self"></a>`self`: borrow<[`incoming-request`](#incoming_request)>

##### Return values

- <a id="method_incoming_request_scheme.0"></a> option<[`scheme`](#scheme)>

#### <a id="method_incoming_request_authority"></a>`[method]incoming-request.authority: func`

Returns the authority from the request, if it was present.

##### Params

- <a id="method_incoming_request_authority.self"></a>`self`: borrow<[`incoming-request`](#incoming_request)>

##### Return values

- <a id="method_incoming_request_authority.0"></a> option<`string`>

#### <a id="method_incoming_request_headers"></a>`[method]incoming-request.headers: func`

Get the `headers` associated with the request.

The returned `headers` resource is immutable: `set`, `append`, and
`delete` operations will fail with `header-error.immutable`.

The `headers` returned are a child resource: it must be dropped before
the parent `incoming-request` is dropped. Dropping this
`incoming-request` before all children are dropped will trap.

##### Params

- <a id="method_incoming_request_headers.self"></a>`self`: borrow<[`incoming-request`](#incoming_request)>

##### Return values

- <a id="method_incoming_request_headers.0"></a> own<[`headers`](#headers)>

#### <a id="method_incoming_request_consume"></a>`[method]incoming-request.consume: func`

Gives the `incoming-body` associated with this request. Will only
return success at most once, and subsequent calls will return error.

##### Params

- <a id="method_incoming_request_consume.self"></a>`self`: borrow<[`incoming-request`](#incoming_request)>

##### Return values

- <a id="method_incoming_request_consume.0"></a> result<own<[`incoming-body`](#incoming_body)>>

#### <a id="constructor_outgoing_request"></a>`[constructor]outgoing-request: func`

Construct a new `outgoing-request` with a default `method` of `GET`, and
`none` values for `path-with-query`, `scheme`, and `authority`.

* `headers` is the HTTP Headers for the Request.

It is possible to construct, or manipulate with the accessor functions
below, an `outgoing-request` with an invalid combination of `scheme`
and `authority`, or `headers` which are not permitted to be sent.
It is the obligation of the `outgoing-handler.handle` implementation
to reject invalid constructions of `outgoing-request`.

##### Params

- <a id="constructor_outgoing_request.headers"></a>`headers`: own<[`headers`](#headers)>

##### Return values

- <a id="constructor_outgoing_request.0"></a> own<[`outgoing-request`](#outgoing_request)>

#### <a id="method_outgoing_request_body"></a>`[method]outgoing-request.body: func`

Returns the resource corresponding to the outgoing Body for this
Request.

Returns success on the first call: the `outgoing-body` resource for
this `outgoing-request` can be retrieved at most once. Subsequent
calls will return error.

##### Params

- <a id="method_outgoing_request_body.self"></a>`self`: borrow<[`outgoing-request`](#outgoing_request)>

##### Return values

- <a id="method_outgoing_request_body.0"></a> result<own<[`outgoing-body`](#outgoing_body)>>

#### <a id="method_outgoing_request_method"></a>`[method]outgoing-request.method: func`

Get the Method for the Request.

##### Params

- <a id="method_outgoing_request_method.self"></a>`self`: borrow<[`outgoing-request`](#outgoing_request)>

##### Return values

- <a id="method_outgoing_request_method.0"></a> [`method`](#method)

#### <a id="method_outgoing_request_set_method"></a>`[method]outgoing-request.set-method: func`

Set the Method for the Request. Fails if the string present in a
`method.other` argument is not a syntactically valid method.

##### Params

- <a id="method_outgoing_request_set_method.self"></a>`self`: borrow<[`outgoing-request`](#outgoing_request)>
- <a id="method_outgoing_request_set_method.method"></a>`method`: [`method`](#method)

##### Return values

- <a id="method_outgoing_request_set_method.0"></a> result

#### <a id="method_outgoing_request_path_with_query"></a>`[method]outgoing-request.path-with-query: func`

Get the combination of the HTTP Path and Query for the Request.
When `none`, this represents an empty Path and empty Query.

##### Params

- <a id="method_outgoing_request_path_with_query.self"></a>`self`: borrow<[`outgoing-request`](#outgoing_request)>

##### Return values

- <a id="method_outgoing_request_path_with_query.0"></a> option<`string`>

#### <a id="method_outgoing_request_set_path_with_query"></a>`[method]outgoing-request.set-path-with-query: func`

Set the combination of the HTTP Path and Query for the Request.
When `none`, this represents an empty Path and empty Query. Fails is the
string given is not a syntactically valid path and query uri component.

##### Params

- <a id="method_outgoing_request_set_path_with_query.self"></a>`self`: borrow<[`outgoing-request`](#outgoing_request)>
- <a id="method_outgoing_request_set_path_with_query.path_with_query"></a>`path-with-query`: option<`string`>

##### Return values

- <a id="method_outgoing_request_set_path_with_query.0"></a> result

#### <a id="method_outgoing_request_scheme"></a>`[method]outgoing-request.scheme: func`

Get the HTTP Related Scheme for the Request. When `none`, the
implementation may choose an appropriate default scheme.

##### Params

- <a id="method_outgoing_request_scheme.self"></a>`self`: borrow<[`outgoing-request`](#outgoing_request)>

##### Return values

- <a id="method_outgoing_request_scheme.0"></a> option<[`scheme`](#scheme)>

#### <a id="method_outgoing_request_set_scheme"></a>`[method]outgoing-request.set-scheme: func`

Set the HTTP Related Scheme for the Request. When `none`, the
implementation may choose an appropriate default scheme. Fails if the
string given is not a syntactically valid uri scheme.

##### Params

- <a id="method_outgoing_request_set_scheme.self"></a>`self`: borrow<[`outgoing-request`](#outgoing_request)>
- <a id="method_outgoing_request_set_scheme.scheme"></a>`scheme`: option<[`scheme`](#scheme)>

##### Return values

- <a id="method_outgoing_request_set_scheme.0"></a> result

#### <a id="method_outgoing_request_authority"></a>`[method]outgoing-request.authority: func`

Get the HTTP Authority for the Request. A value of `none` may be used
with Related Schemes which do not require an Authority. The HTTP and
HTTPS schemes always require an authority.

##### Params

- <a id="method_outgoing_request_authority.self"></a>`self`: borrow<[`outgoing-request`](#outgoing_request)>

##### Return values

- <a id="method_outgoing_request_authority.0"></a> option<`string`>

#### <a id="method_outgoing_request_set_authority"></a>`[method]outgoing-request.set-authority: func`

Set the HTTP Authority for the Request. A value of `none` may be used
with Related Schemes which do not require an Authority. The HTTP and
HTTPS schemes always require an authority. Fails if the string given is
not a syntactically valid uri authority.

##### Params

- <a id="method_outgoing_request_set_authority.self"></a>`self`: borrow<[`outgoing-request`](#outgoing_request)>
- <a id="method_outgoing_request_set_authority.authority"></a>`authority`: option<`string`>

##### Return values

- <a id="method_outgoing_request_set_authority.0"></a> result

#### <a id="method_outgoing_request_headers"></a>`[method]outgoing-request.headers: func`

Get the headers associated with the Request.

The returned `headers` resource is immutable: `set`, `append`, and
`delete` operations will fail with `header-error.immutable`.

This headers resource is a child: it must be dropped before the parent
`outgoing-request` is dropped, or its ownership is transfered to
another component by e.g. `outgoing-handler.handle`.

##### Params

- <a id="method_outgoing_request_headers.self"></a>`self`: borrow<[`outgoing-request`](#outgoing_request)>

##### Return values

- <a id="method_outgoing_request_headers.0"></a> own<[`headers`](#headers)>

#### <a id="constructor_request_options"></a>`[constructor]request-options: func`

Construct a default `request-options` value.

##### Return values

- <a id="constructor_request_options.0"></a> own<[`request-options`](#request_options)>

#### <a id="method_request_options_connect_timeout"></a>`[method]request-options.connect-timeout: func`

The timeout for the initial connect to the HTTP Server.

##### Params

- <a id="method_request_options_connect_timeout.self"></a>`self`: borrow<[`request-options`](#request_options)>

##### Return values

- <a id="method_request_options_connect_timeout.0"></a> option<[`duration`](#duration)>

#### <a id="method_request_options_set_connect_timeout"></a>`[method]request-options.set-connect-timeout: func`

Set the timeout for the initial connect to the HTTP Server. An error
return value indicates that this timeout is not supported.

##### Params

- <a id="method_request_options_set_connect_timeout.self"></a>`self`: borrow<[`request-options`](#request_options)>
- <a id="method_request_options_set_connect_timeout.duration"></a>`duration`: option<[`duration`](#duration)>

##### Return values

- <a id="method_request_options_set_connect_timeout.0"></a> result

#### <a id="method_request_options_first_byte_timeout"></a>`[method]request-options.first-byte-timeout: func`

The timeout for receiving the first byte of the Response body.

##### Params

- <a id="method_request_options_first_byte_timeout.self"></a>`self`: borrow<[`request-options`](#request_options)>

##### Return values

- <a id="method_request_options_first_byte_timeout.0"></a> option<[`duration`](#duration)>

#### <a id="method_request_options_set_first_byte_timeout"></a>`[method]request-options.set-first-byte-timeout: func`

Set the timeout for receiving the first byte of the Response body. An
error return value indicates that this timeout is not supported.

##### Params

- <a id="method_request_options_set_first_byte_timeout.self"></a>`self`: borrow<[`request-options`](#request_options)>
- <a id="method_request_options_set_first_byte_timeout.duration"></a>`duration`: option<[`duration`](#duration)>

##### Return values

- <a id="method_request_options_set_first_byte_timeout.0"></a> result

#### <a id="method_request_options_between_bytes_timeout"></a>`[method]request-options.between-bytes-timeout: func`

The timeout for receiving subsequent chunks of bytes in the Response
body stream.

##### Params

- <a id="method_request_options_between_bytes_timeout.self"></a>`self`: borrow<[`request-options`](#request_options)>

##### Return values

- <a id="method_request_options_between_bytes_timeout.0"></a> option<[`duration`](#duration)>

#### <a id="method_request_options_set_between_bytes_timeout"></a>`[method]request-options.set-between-bytes-timeout: func`

Set the timeout for receiving subsequent chunks of bytes in the Response
body stream. An error return value indicates that this timeout is not
supported.

##### Params

- <a id="method_request_options_set_between_bytes_timeout.self"></a>`self`: borrow<[`request-options`](#request_options)>
- <a id="method_request_options_set_between_bytes_timeout.duration"></a>`duration`: option<[`duration`](#duration)>

##### Return values

- <a id="method_request_options_set_between_bytes_timeout.0"></a> result

#### <a id="static_response_outparam_set"></a>`[static]response-outparam.set: func`

Set the value of the `response-outparam` to either send a response,
or indicate an error.

This method consumes the `response-outparam` to ensure that it is
called at most once. If it is never called, the implementation
will respond with an error.

The user may provide an `error` to `response` to allow the
implementation determine how to respond with an HTTP error response.

##### Params

- <a id="static_response_outparam_set.param"></a>`param`: own<[`response-outparam`](#response_outparam)>
- <a id="static_response_outparam_set.response"></a>`response`: result<own<[`outgoing-response`](#outgoing_response)>, [`error-code`](#error_code)>

#### <a id="method_incoming_response_status"></a>`[method]incoming-response.status: func`

Returns the status code from the incoming response.

##### Params

- <a id="method_incoming_response_status.self"></a>`self`: borrow<[`incoming-response`](#incoming_response)>

##### Return values

- <a id="method_incoming_response_status.0"></a> [`status-code`](#status_code)

#### <a id="method_incoming_response_headers"></a>`[method]incoming-response.headers: func`

Returns the headers from the incoming response.

The returned `headers` resource is immutable: `set`, `append`, and
`delete` operations will fail with `header-error.immutable`.

This headers resource is a child: it must be dropped before the parent
`incoming-response` is dropped.

##### Params

- <a id="method_incoming_response_headers.self"></a>`self`: borrow<[`incoming-response`](#incoming_response)>

##### Return values

- <a id="method_incoming_response_headers.0"></a> own<[`headers`](#headers)>

#### <a id="method_incoming_response_consume"></a>`[method]incoming-response.consume: func`

Returns the incoming body. May be called at most once. Returns error
if called additional times.

##### Params

- <a id="method_incoming_response_consume.self"></a>`self`: borrow<[`incoming-response`](#incoming_response)>

##### Return values

- <a id="method_incoming_response_consume.0"></a> result<own<[`incoming-body`](#incoming_body)>>

#### <a id="method_incoming_body_stream"></a>`[method]incoming-body.stream: func`

Returns the contents of the body, as a stream of bytes.

Returns success on first call: the stream representing the contents
can be retrieved at most once. Subsequent calls will return error.

The returned `input-stream` resource is a child: it must be dropped
before the parent `incoming-body` is dropped, or consumed by
`incoming-body.finish`.

This invariant ensures that the implementation can determine whether
the user is consuming the contents of the body, waiting on the
`future-trailers` to be ready, or neither. This allows for network
backpressure is to be applied when the user is consuming the body,
and for that backpressure to not inhibit delivery of the trailers if
the user does not read the entire body.

##### Params

- <a id="method_incoming_body_stream.self"></a>`self`: borrow<[`incoming-body`](#incoming_body)>

##### Return values

- <a id="method_incoming_body_stream.0"></a> result<own<[`input-stream`](#input_stream)>>

#### <a id="static_incoming_body_finish"></a>`[static]incoming-body.finish: func`

Takes ownership of `incoming-body`, and returns a `future-trailers`.
This function will trap if the `input-stream` child is still alive.

##### Params

- <a id="static_incoming_body_finish.this"></a>`this`: own<[`incoming-body`](#incoming_body)>

##### Return values

- <a id="static_incoming_body_finish.0"></a> own<[`future-trailers`](#future_trailers)>

#### <a id="method_future_trailers_subscribe"></a>`[method]future-trailers.subscribe: func`

Returns a pollable which becomes ready when either the trailers have
been received, or an error has occured. When this pollable is ready,
the `get` method will return `some`.

##### Params

- <a id="method_future_trailers_subscribe.self"></a>`self`: borrow<[`future-trailers`](#future_trailers)>

##### Return values

- <a id="method_future_trailers_subscribe.0"></a> own<[`pollable`](#pollable)>

#### <a id="method_future_trailers_get"></a>`[method]future-trailers.get: func`

Returns the contents of the trailers, or an error which occured,
once the future is ready.

The outer `option` represents future readiness. Users can wait on this
`option` to become `some` using the `subscribe` method.

The outer `result` is used to retrieve the trailers or error at most
once. It will be success on the first call in which the outer option
is `some`, and error on subsequent calls.

The inner `result` represents that either the HTTP Request or Response
body, as well as any trailers, were received successfully, or that an
error occured receiving them. The optional `trailers` indicates whether
or not trailers were present in the body.

When some `trailers` are returned by this method, the `trailers`
resource is immutable, and a child. Use of the `set`, `append`, or
`delete` methods will return an error, and the resource must be
dropped before the parent `future-trailers` is dropped.

##### Params

- <a id="method_future_trailers_get.self"></a>`self`: borrow<[`future-trailers`](#future_trailers)>

##### Return values

- <a id="method_future_trailers_get.0"></a> option<result<result<option<own<[`trailers`](#trailers)>>, [`error-code`](#error_code)>>>

#### <a id="constructor_outgoing_response"></a>`[constructor]outgoing-response: func`

Construct an `outgoing-response`, with a default `status-code` of `200`.
If a different `status-code` is needed, it must be set via the
`set-status-code` method.

* `headers` is the HTTP Headers for the Response.

##### Params

- <a id="constructor_outgoing_response.headers"></a>`headers`: own<[`headers`](#headers)>

##### Return values

- <a id="constructor_outgoing_response.0"></a> own<[`outgoing-response`](#outgoing_response)>

#### <a id="method_outgoing_response_status_code"></a>`[method]outgoing-response.status-code: func`

Get the HTTP Status Code for the Response.

##### Params

- <a id="method_outgoing_response_status_code.self"></a>`self`: borrow<[`outgoing-response`](#outgoing_response)>

##### Return values

- <a id="method_outgoing_response_status_code.0"></a> [`status-code`](#status_code)

#### <a id="method_outgoing_response_set_status_code"></a>`[method]outgoing-response.set-status-code: func`

Set the HTTP Status Code for the Response. Fails if the status-code
given is not a valid http status code.

##### Params

- <a id="method_outgoing_response_set_status_code.self"></a>`self`: borrow<[`outgoing-response`](#outgoing_response)>
- <a id="method_outgoing_response_set_status_code.status_code"></a>`status-code`: [`status-code`](#status_code)

##### Return values

- <a id="method_outgoing_response_set_status_code.0"></a> result

#### <a id="method_outgoing_response_headers"></a>`[method]outgoing-response.headers: func`

Get the headers associated with the Request.

The returned `headers` resource is immutable: `set`, `append`, and
`delete` operations will fail with `header-error.immutable`.

This headers resource is a child: it must be dropped before the parent
`outgoing-request` is dropped, or its ownership is transfered to
another component by e.g. `outgoing-handler.handle`.

##### Params

- <a id="method_outgoing_response_headers.self"></a>`self`: borrow<[`outgoing-response`](#outgoing_response)>

##### Return values

- <a id="method_outgoing_response_headers.0"></a> own<[`headers`](#headers)>

#### <a id="method_outgoing_response_body"></a>`[method]outgoing-response.body: func`

Returns the resource corresponding to the outgoing Body for this Response.

Returns success on the first call: the `outgoing-body` resource for
this `outgoing-response` can be retrieved at most once. Subsequent
calls will return error.

##### Params

- <a id="method_outgoing_response_body.self"></a>`self`: borrow<[`outgoing-response`](#outgoing_response)>

##### Return values

- <a id="method_outgoing_response_body.0"></a> result<own<[`outgoing-body`](#outgoing_body)>>

#### <a id="method_outgoing_body_write"></a>`[method]outgoing-body.write: func`

Returns a stream for writing the body contents.

The returned `output-stream` is a child resource: it must be dropped
before the parent `outgoing-body` resource is dropped (or finished),
otherwise the `outgoing-body` drop or `finish` will trap.

Returns success on the first call: the `output-stream` resource for
this `outgoing-body` may be retrieved at most once. Subsequent calls
will return error.

##### Params

- <a id="method_outgoing_body_write.self"></a>`self`: borrow<[`outgoing-body`](#outgoing_body)>

##### Return values

- <a id="method_outgoing_body_write.0"></a> result<own<[`output-stream`](#output_stream)>>

#### <a id="static_outgoing_body_finish"></a>`[static]outgoing-body.finish: func`

Finalize an outgoing body, optionally providing trailers. This must be
called to signal that the response is complete. If the `outgoing-body`
is dropped without calling `outgoing-body.finalize`, the implementation
should treat the body as corrupted.

Fails if the body's `outgoing-request` or `outgoing-response` was
constructed with a Content-Length header, and the contents written
to the body (via `write`) does not match the value given in the
Content-Length.

##### Params

- <a id="static_outgoing_body_finish.this"></a>`this`: own<[`outgoing-body`](#outgoing_body)>
- <a id="static_outgoing_body_finish.trailers"></a>`trailers`: option<own<[`trailers`](#trailers)>>

##### Return values

- <a id="static_outgoing_body_finish.0"></a> result<_, [`error-code`](#error_code)>

#### <a id="method_future_incoming_response_subscribe"></a>`[method]future-incoming-response.subscribe: func`

Returns a pollable which becomes ready when either the Response has
been received, or an error has occured. When this pollable is ready,
the `get` method will return `some`.

##### Params

- <a id="method_future_incoming_response_subscribe.self"></a>`self`: borrow<[`future-incoming-response`](#future_incoming_response)>

##### Return values

- <a id="method_future_incoming_response_subscribe.0"></a> own<[`pollable`](#pollable)>

#### <a id="method_future_incoming_response_get"></a>`[method]future-incoming-response.get: func`

Returns the incoming HTTP Response, or an error, once one is ready.

The outer `option` represents future readiness. Users can wait on this
`option` to become `some` using the `subscribe` method.

The outer `result` is used to retrieve the response or error at most
once. It will be success on the first call in which the outer option
is `some`, and error on subsequent calls.

The inner `result` represents that either the incoming HTTP Response
status and headers have recieved successfully, or that an error
occured. Errors may also occur while consuming the response body,
but those will be reported by the `incoming-body` and its
`output-stream` child.

##### Params

- <a id="method_future_incoming_response_get.self"></a>`self`: borrow<[`future-incoming-response`](#future_incoming_response)>

##### Return values

- <a id="method_future_incoming_response_get.0"></a> option<result<result<own<[`incoming-response`](#incoming_response)>, [`error-code`](#error_code)>>>

## <a id="wasi_http_incoming_handler_0_2_0"></a>Export interface wasi:http/incoming-handler@0.2.0

----

### Types

#### <a id="incoming_request"></a>`type incoming-request`
[`incoming-request`](#incoming_request)
<p>
#### <a id="response_outparam"></a>`type response-outparam`
[`response-outparam`](#response_outparam)
<p>
----

### Functions

#### <a id="handle"></a>`handle: func`

This function is invoked with an incoming HTTP Request, and a resource
`response-outparam` which provides the capability to reply with an HTTP
Response. The response is sent by calling the `response-outparam.set`
method, which allows execution to continue after the response has been
sent. This enables both streaming to the response body, and performing other
work.

The implementor of this function must write a response to the
`response-outparam` before returning, or else the caller will respond
with an error on its behalf.

##### Params

- <a id="handle.request"></a>`request`: own<[`incoming-request`](#incoming_request)>
- <a id="handle.response_out"></a>`response-out`: own<[`response-outparam`](#response_outparam)>

## <a id="hayride_http_config_0_0_50"></a>Export interface hayride:http/config@0.0.50

----

### Types

#### <a id="server"></a>`record server`


##### Record Fields

- <a id="server.address"></a>`address`: `string`
- <a id="server.read_timeout"></a>`read-timeout`: `u32`
- <a id="server.write_timeout"></a>`write-timeout`: `u32`
- <a id="server.max_header_bytes"></a>`max-header-bytes`: `u32`
#### <a id="error_code"></a>`enum error-code`


##### Enum Cases

- <a id="error_code.invalid"></a>`invalid`
- <a id="error_code.not_found"></a>`not-found`
- <a id="error_code.unknown"></a>`unknown`
#### <a id="error"></a>`resource error`

----

### Functions

#### <a id="method_error_code"></a>`[method]error.code: func`


##### Params

- <a id="method_error_code.self"></a>`self`: borrow<[`error`](#error)>

##### Return values

- <a id="method_error_code.0"></a> [`error-code`](#error_code)

#### <a id="method_error_data"></a>`[method]error.data: func`


##### Params

- <a id="method_error_data.self"></a>`self`: borrow<[`error`](#error)>

##### Return values

- <a id="method_error_data.0"></a> `string`

#### <a id="get"></a>`get: func`


##### Return values

- <a id="get.0"></a> result<[`server`](#server), own<[`error`](#error)>>

