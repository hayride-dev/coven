# <a id="runtime"></a>World runtime


 - Imports:
    - interface `wasi:clocks/wall-clock@0.2.0`
    - interface `wasi:io/poll@0.2.0`
    - interface `wasi:clocks/monotonic-clock@0.2.0`
    - interface `wasi:random/random@0.2.0`
    - interface `wasi:io/error@0.2.0`
    - interface `wasi:io/streams@0.2.0`
    - interface `wasi:filesystem/types@0.2.0`
    - interface `wasi:filesystem/preopens@0.2.0`
    - interface `wasi:cli/stdout@0.2.0`
    - interface `wasi:cli/stderr@0.2.0`
    - interface `wasi:cli/stdin@0.2.0`
    - interface `wasi:cli/environment@0.2.0`
    - interface `wasi:cli/exit@0.2.0`
    - interface `wasi:http/types@0.2.0`
    - interface `wasi:http/outgoing-handler@0.2.0`
    - interface `wasi:nn/tensor@0.2.0-rc-2024-08-19`
    - interface `wasi:nn/errors@0.2.0-rc-2024-08-19`
    - interface `wasi:nn/inference@0.2.0-rc-2024-08-19`
    - interface `wasi:nn/graph@0.2.0-rc-2024-08-19`
 - Exports:
    - interface `wasi:cli/run@0.2.0`

## <a id="wasi_clocks_wall_clock_0_2_0"></a>Import interface wasi:clocks/wall-clock@0.2.0

WASI Wall Clock is a clock API intended to let users query the current
time. The name "wall" makes an analogy to a "clock on the wall", which
is not necessarily monotonic as it may be reset.

It is intended to be portable at least between Unix-family platforms and
Windows.

A wall clock is a clock which measures the date and time according to
some external reference.

External references may be reset, so this clock is not necessarily
monotonic, making it unsuitable for measuring elapsed time.

It is intended for reporting the current date and time for humans.

----

### Types

#### <a id="datetime"></a>`record datetime`

A time and date in seconds plus nanoseconds.

##### Record Fields

- <a id="datetime.seconds"></a>`seconds`: `u64`
- <a id="datetime.nanoseconds"></a>`nanoseconds`: `u32`
----

### Functions

#### <a id="now"></a>`now: func`

Read the current value of the clock.

This clock is not monotonic, therefore calling this function repeatedly
will not necessarily produce a sequence of non-decreasing values.

The returned timestamps represent the number of seconds since
1970-01-01T00:00:00Z, also known as [POSIX's Seconds Since the Epoch],
also known as [Unix Time].

The nanoseconds field of the output is always less than 1000000000.

[POSIX's Seconds Since the Epoch]: https://pubs.opengroup.org/onlinepubs/9699919799/xrat/V4_xbd_chap04.html#tag_21_04_16
[Unix Time]: https://en.wikipedia.org/wiki/Unix_time

##### Return values

- <a id="now.0"></a> [`datetime`](#datetime)

#### <a id="resolution"></a>`resolution: func`

Query the resolution of the clock.

The nanoseconds field of the output is always less than 1000000000.

##### Return values

- <a id="resolution.0"></a> [`datetime`](#datetime)

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

## <a id="wasi_random_random_0_2_0"></a>Import interface wasi:random/random@0.2.0

WASI Random is a random data API.

It is intended to be portable at least between Unix-family platforms and
Windows.

----

### Functions

#### <a id="get_random_bytes"></a>`get-random-bytes: func`

Return `len` cryptographically-secure random or pseudo-random bytes.

This function must produce data at least as cryptographically secure and
fast as an adequately seeded cryptographically-secure pseudo-random
number generator (CSPRNG). It must not block, from the perspective of
the calling program, under any circumstances, including on the first
request and on requests for numbers of bytes. The returned data must
always be unpredictable.

This function must always return fresh data. Deterministic environments
must omit this function, rather than implementing it with deterministic
data.

##### Params

- <a id="get_random_bytes.len"></a>`len`: `u64`

##### Return values

- <a id="get_random_bytes.0"></a> list<`u8`>

#### <a id="get_random_u64"></a>`get-random-u64: func`

Return a cryptographically-secure random or pseudo-random `u64` value.

This function returns the same type of data as `get-random-bytes`,
represented as a `u64`.

##### Return values

- <a id="get_random_u64.0"></a> `u64`

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

## <a id="wasi_filesystem_types_0_2_0"></a>Import interface wasi:filesystem/types@0.2.0

WASI filesystem is a filesystem API primarily intended to let users run WASI
programs that access their files on their existing filesystems, without
significant overhead.

It is intended to be roughly portable between Unix-family platforms and
Windows, though it does not hide many of the major differences.

Paths are passed as interface-type `string`s, meaning they must consist of
a sequence of Unicode Scalar Values (USVs). Some filesystems may contain
paths which are not accessible by this API.

The directory separator in WASI is always the forward-slash (`/`).

All paths in WASI are relative paths, and are interpreted relative to a
`descriptor` referring to a base directory. If a `path` argument to any WASI
function starts with `/`, or if any step of resolving a `path`, including
`..` and symbolic link steps, reaches a directory outside of the base
directory, or reaches a symlink to an absolute or rooted path in the
underlying filesystem, the function fails with `error-code::not-permitted`.

For more information about WASI path resolution and sandboxing, see
[WASI filesystem path resolution].

[WASI filesystem path resolution]: https://github.com/WebAssembly/wasi-filesystem/blob/main/path-resolution.md

----

### Types

#### <a id="input_stream"></a>`type input-stream`
[`input-stream`](#input_stream)
<p>
#### <a id="output_stream"></a>`type output-stream`
[`output-stream`](#output_stream)
<p>
#### <a id="error"></a>`type error`
[`error`](#error)
<p>
#### <a id="datetime"></a>`type datetime`
[`datetime`](#datetime)
<p>
#### <a id="filesize"></a>`type filesize`
`u64`
<p>File size or length of a region within a file.

#### <a id="descriptor_type"></a>`enum descriptor-type`

The type of a filesystem object referenced by a descriptor.

Note: This was called `filetype` in earlier versions of WASI.

##### Enum Cases

- <a id="descriptor_type.unknown"></a>`unknown`
  <p>The type of the descriptor or file is unknown or is different from
  any of the other types specified.

- <a id="descriptor_type.block_device"></a>`block-device`
  <p>The descriptor refers to a block device inode.

- <a id="descriptor_type.character_device"></a>`character-device`
  <p>The descriptor refers to a character device inode.

- <a id="descriptor_type.directory"></a>`directory`
  <p>The descriptor refers to a directory inode.

- <a id="descriptor_type.fifo"></a>`fifo`
  <p>The descriptor refers to a named pipe.

- <a id="descriptor_type.symbolic_link"></a>`symbolic-link`
  <p>The file refers to a symbolic link inode.

- <a id="descriptor_type.regular_file"></a>`regular-file`
  <p>The descriptor refers to a regular file inode.

- <a id="descriptor_type.socket"></a>`socket`
  <p>The descriptor refers to a socket.

#### <a id="descriptor_flags"></a>`flags descriptor-flags`

Descriptor flags.

Note: This was called `fdflags` in earlier versions of WASI.

##### Flags members

- <a id="descriptor_flags.read"></a>`read`: 
  <p>Read mode: Data can be read.

- <a id="descriptor_flags.write"></a>`write`: 
  <p>Write mode: Data can be written to.

- <a id="descriptor_flags.file_integrity_sync"></a>`file-integrity-sync`: 
  <p>Request that writes be performed according to synchronized I/O file
  integrity completion. The data stored in the file and the file's
  metadata are synchronized. This is similar to `O_SYNC` in POSIX.

  The precise semantics of this operation have not yet been defined for
  WASI. At this time, it should be interpreted as a request, and not a
  requirement.

- <a id="descriptor_flags.data_integrity_sync"></a>`data-integrity-sync`: 
  <p>Request that writes be performed according to synchronized I/O data
  integrity completion. Only the data stored in the file is
  synchronized. This is similar to `O_DSYNC` in POSIX.

  The precise semantics of this operation have not yet been defined for
  WASI. At this time, it should be interpreted as a request, and not a
  requirement.

- <a id="descriptor_flags.requested_write_sync"></a>`requested-write-sync`: 
  <p>Requests that reads be performed at the same level of integrety
  requested for writes. This is similar to `O_RSYNC` in POSIX.

  The precise semantics of this operation have not yet been defined for
  WASI. At this time, it should be interpreted as a request, and not a
  requirement.

- <a id="descriptor_flags.mutate_directory"></a>`mutate-directory`: 
  <p>Mutating directories mode: Directory contents may be mutated.

  When this flag is unset on a descriptor, operations using the
  descriptor which would create, rename, delete, modify the data or
  metadata of filesystem objects, or obtain another handle which
  would permit any of those, shall fail with `error-code::read-only` if
  they would otherwise succeed.

  This may only be set on directories.

#### <a id="path_flags"></a>`flags path-flags`

Flags determining the method of how paths are resolved.

##### Flags members

- <a id="path_flags.symlink_follow"></a>`symlink-follow`: 
  <p>As long as the resolved path corresponds to a symbolic link, it is
  expanded.

#### <a id="open_flags"></a>`flags open-flags`

Open flags used by `open-at`.

##### Flags members

- <a id="open_flags.create"></a>`create`: 
  <p>Create file if it does not exist, similar to `O_CREAT` in POSIX.

- <a id="open_flags.directory"></a>`directory`: 
  <p>Fail if not a directory, similar to `O_DIRECTORY` in POSIX.

- <a id="open_flags.exclusive"></a>`exclusive`: 
  <p>Fail if file already exists, similar to `O_EXCL` in POSIX.

- <a id="open_flags.truncate"></a>`truncate`: 
  <p>Truncate file to size 0, similar to `O_TRUNC` in POSIX.

#### <a id="link_count"></a>`type link-count`
`u64`
<p>Number of hard links to an inode.

#### <a id="descriptor_stat"></a>`record descriptor-stat`

File attributes.

Note: This was called `filestat` in earlier versions of WASI.

##### Record Fields

- <a id="descriptor_stat.type"></a>`type`: [`descriptor-type`](#descriptor_type)
  <p>File type.

- <a id="descriptor_stat.link_count"></a>`link-count`: [`link-count`](#link_count)
  <p>Number of hard links to the file.

- <a id="descriptor_stat.size"></a>`size`: [`filesize`](#filesize)
  <p>For regular files, the file size in bytes. For symbolic links, the
  length in bytes of the pathname contained in the symbolic link.

- <a id="descriptor_stat.data_access_timestamp"></a>`data-access-timestamp`: option<[`datetime`](#datetime)>
  <p>Last data access timestamp.

  If the `option` is none, the platform doesn't maintain an access
  timestamp for this file.

- <a id="descriptor_stat.data_modification_timestamp"></a>`data-modification-timestamp`: option<[`datetime`](#datetime)>
  <p>Last data modification timestamp.

  If the `option` is none, the platform doesn't maintain a
  modification timestamp for this file.

- <a id="descriptor_stat.status_change_timestamp"></a>`status-change-timestamp`: option<[`datetime`](#datetime)>
  <p>Last file status-change timestamp.

  If the `option` is none, the platform doesn't maintain a
  status-change timestamp for this file.

#### <a id="new_timestamp"></a>`variant new-timestamp`

When setting a timestamp, this gives the value to set it to.

##### Variant Cases

- <a id="new_timestamp.no_change"></a>`no-change`
  <p>Leave the timestamp set to its previous value.

- <a id="new_timestamp.now"></a>`now`
  <p>Set the timestamp to the current time of the system clock associated
  with the filesystem.

- <a id="new_timestamp.timestamp"></a>`timestamp`: [`datetime`](#datetime)
  <p>Set the timestamp to the given value.

#### <a id="directory_entry"></a>`record directory-entry`

A directory entry.

##### Record Fields

- <a id="directory_entry.type"></a>`type`: [`descriptor-type`](#descriptor_type)
  <p>The type of the file referred to by this directory entry.

- <a id="directory_entry.name"></a>`name`: `string`
  <p>The name of the object.

#### <a id="error_code"></a>`enum error-code`

Error codes returned by functions, similar to `errno` in POSIX.
Not all of these error codes are returned by the functions provided by this
API; some are used in higher-level library layers, and others are provided
merely for alignment with POSIX.

##### Enum Cases

- <a id="error_code.access"></a>`access`
  <p>Permission denied, similar to `EACCES` in POSIX.

- <a id="error_code.would_block"></a>`would-block`
  <p>Resource unavailable, or operation would block, similar to `EAGAIN` and `EWOULDBLOCK` in POSIX.

- <a id="error_code.already"></a>`already`
  <p>Connection already in progress, similar to `EALREADY` in POSIX.

- <a id="error_code.bad_descriptor"></a>`bad-descriptor`
  <p>Bad descriptor, similar to `EBADF` in POSIX.

- <a id="error_code.busy"></a>`busy`
  <p>Device or resource busy, similar to `EBUSY` in POSIX.

- <a id="error_code.deadlock"></a>`deadlock`
  <p>Resource deadlock would occur, similar to `EDEADLK` in POSIX.

- <a id="error_code.quota"></a>`quota`
  <p>Storage quota exceeded, similar to `EDQUOT` in POSIX.

- <a id="error_code.exist"></a>`exist`
  <p>File exists, similar to `EEXIST` in POSIX.

- <a id="error_code.file_too_large"></a>`file-too-large`
  <p>File too large, similar to `EFBIG` in POSIX.

- <a id="error_code.illegal_byte_sequence"></a>`illegal-byte-sequence`
  <p>Illegal byte sequence, similar to `EILSEQ` in POSIX.

- <a id="error_code.in_progress"></a>`in-progress`
  <p>Operation in progress, similar to `EINPROGRESS` in POSIX.

- <a id="error_code.interrupted"></a>`interrupted`
  <p>Interrupted function, similar to `EINTR` in POSIX.

- <a id="error_code.invalid"></a>`invalid`
  <p>Invalid argument, similar to `EINVAL` in POSIX.

- <a id="error_code.io"></a>`io`
  <p>I/O error, similar to `EIO` in POSIX.

- <a id="error_code.is_directory"></a>`is-directory`
  <p>Is a directory, similar to `EISDIR` in POSIX.

- <a id="error_code.loop"></a>`loop`
  <p>Too many levels of symbolic links, similar to `ELOOP` in POSIX.

- <a id="error_code.too_many_links"></a>`too-many-links`
  <p>Too many links, similar to `EMLINK` in POSIX.

- <a id="error_code.message_size"></a>`message-size`
  <p>Message too large, similar to `EMSGSIZE` in POSIX.

- <a id="error_code.name_too_long"></a>`name-too-long`
  <p>Filename too long, similar to `ENAMETOOLONG` in POSIX.

- <a id="error_code.no_device"></a>`no-device`
  <p>No such device, similar to `ENODEV` in POSIX.

- <a id="error_code.no_entry"></a>`no-entry`
  <p>No such file or directory, similar to `ENOENT` in POSIX.

- <a id="error_code.no_lock"></a>`no-lock`
  <p>No locks available, similar to `ENOLCK` in POSIX.

- <a id="error_code.insufficient_memory"></a>`insufficient-memory`
  <p>Not enough space, similar to `ENOMEM` in POSIX.

- <a id="error_code.insufficient_space"></a>`insufficient-space`
  <p>No space left on device, similar to `ENOSPC` in POSIX.

- <a id="error_code.not_directory"></a>`not-directory`
  <p>Not a directory or a symbolic link to a directory, similar to `ENOTDIR` in POSIX.

- <a id="error_code.not_empty"></a>`not-empty`
  <p>Directory not empty, similar to `ENOTEMPTY` in POSIX.

- <a id="error_code.not_recoverable"></a>`not-recoverable`
  <p>State not recoverable, similar to `ENOTRECOVERABLE` in POSIX.

- <a id="error_code.unsupported"></a>`unsupported`
  <p>Not supported, similar to `ENOTSUP` and `ENOSYS` in POSIX.

- <a id="error_code.no_tty"></a>`no-tty`
  <p>Inappropriate I/O control operation, similar to `ENOTTY` in POSIX.

- <a id="error_code.no_such_device"></a>`no-such-device`
  <p>No such device or address, similar to `ENXIO` in POSIX.

- <a id="error_code.overflow"></a>`overflow`
  <p>Value too large to be stored in data type, similar to `EOVERFLOW` in POSIX.

- <a id="error_code.not_permitted"></a>`not-permitted`
  <p>Operation not permitted, similar to `EPERM` in POSIX.

- <a id="error_code.pipe"></a>`pipe`
  <p>Broken pipe, similar to `EPIPE` in POSIX.

- <a id="error_code.read_only"></a>`read-only`
  <p>Read-only file system, similar to `EROFS` in POSIX.

- <a id="error_code.invalid_seek"></a>`invalid-seek`
  <p>Invalid seek, similar to `ESPIPE` in POSIX.

- <a id="error_code.text_file_busy"></a>`text-file-busy`
  <p>Text file busy, similar to `ETXTBSY` in POSIX.

- <a id="error_code.cross_device"></a>`cross-device`
  <p>Cross-device link, similar to `EXDEV` in POSIX.

#### <a id="advice"></a>`enum advice`

File or memory access pattern advisory information.

##### Enum Cases

- <a id="advice.normal"></a>`normal`
  <p>The application has no advice to give on its behavior with respect
  to the specified data.

- <a id="advice.sequential"></a>`sequential`
  <p>The application expects to access the specified data sequentially
  from lower offsets to higher offsets.

- <a id="advice.random"></a>`random`
  <p>The application expects to access the specified data in a random
  order.

- <a id="advice.will_need"></a>`will-need`
  <p>The application expects to access the specified data in the near
  future.

- <a id="advice.dont_need"></a>`dont-need`
  <p>The application expects that it will not access the specified data
  in the near future.

- <a id="advice.no_reuse"></a>`no-reuse`
  <p>The application expects to access the specified data once and then
  not reuse it thereafter.

#### <a id="metadata_hash_value"></a>`record metadata-hash-value`

A 128-bit hash value, split into parts because wasm doesn't have a
128-bit integer type.

##### Record Fields

- <a id="metadata_hash_value.lower"></a>`lower`: `u64`
  <p>64 bits of a 128-bit hash value.

- <a id="metadata_hash_value.upper"></a>`upper`: `u64`
  <p>Another 64 bits of a 128-bit hash value.

#### <a id="descriptor"></a>`resource descriptor`

A descriptor is a reference to a filesystem object, which may be a file,
directory, named pipe, special file, or other object on which filesystem
calls may be made.
#### <a id="directory_entry_stream"></a>`resource directory-entry-stream`

A stream of directory entries.
----

### Functions

#### <a id="method_descriptor_read_via_stream"></a>`[method]descriptor.read-via-stream: func`

Return a stream for reading from a file, if available.

May fail with an error-code describing why the file cannot be read.

Multiple read, write, and append streams may be active on the same open
file and they do not interfere with each other.

Note: This allows using `read-stream`, which is similar to `read` in POSIX.

##### Params

- <a id="method_descriptor_read_via_stream.self"></a>`self`: borrow<[`descriptor`](#descriptor)>
- <a id="method_descriptor_read_via_stream.offset"></a>`offset`: [`filesize`](#filesize)

##### Return values

- <a id="method_descriptor_read_via_stream.0"></a> result<own<[`input-stream`](#input_stream)>, [`error-code`](#error_code)>

#### <a id="method_descriptor_write_via_stream"></a>`[method]descriptor.write-via-stream: func`

Return a stream for writing to a file, if available.

May fail with an error-code describing why the file cannot be written.

Note: This allows using `write-stream`, which is similar to `write` in
POSIX.

##### Params

- <a id="method_descriptor_write_via_stream.self"></a>`self`: borrow<[`descriptor`](#descriptor)>
- <a id="method_descriptor_write_via_stream.offset"></a>`offset`: [`filesize`](#filesize)

##### Return values

- <a id="method_descriptor_write_via_stream.0"></a> result<own<[`output-stream`](#output_stream)>, [`error-code`](#error_code)>

#### <a id="method_descriptor_append_via_stream"></a>`[method]descriptor.append-via-stream: func`

Return a stream for appending to a file, if available.

May fail with an error-code describing why the file cannot be appended.

Note: This allows using `write-stream`, which is similar to `write` with
`O_APPEND` in in POSIX.

##### Params

- <a id="method_descriptor_append_via_stream.self"></a>`self`: borrow<[`descriptor`](#descriptor)>

##### Return values

- <a id="method_descriptor_append_via_stream.0"></a> result<own<[`output-stream`](#output_stream)>, [`error-code`](#error_code)>

#### <a id="method_descriptor_advise"></a>`[method]descriptor.advise: func`

Provide file advisory information on a descriptor.

This is similar to `posix_fadvise` in POSIX.

##### Params

- <a id="method_descriptor_advise.self"></a>`self`: borrow<[`descriptor`](#descriptor)>
- <a id="method_descriptor_advise.offset"></a>`offset`: [`filesize`](#filesize)
- <a id="method_descriptor_advise.length"></a>`length`: [`filesize`](#filesize)
- <a id="method_descriptor_advise.advice"></a>`advice`: [`advice`](#advice)

##### Return values

- <a id="method_descriptor_advise.0"></a> result<_, [`error-code`](#error_code)>

#### <a id="method_descriptor_sync_data"></a>`[method]descriptor.sync-data: func`

Synchronize the data of a file to disk.

This function succeeds with no effect if the file descriptor is not
opened for writing.

Note: This is similar to `fdatasync` in POSIX.

##### Params

- <a id="method_descriptor_sync_data.self"></a>`self`: borrow<[`descriptor`](#descriptor)>

##### Return values

- <a id="method_descriptor_sync_data.0"></a> result<_, [`error-code`](#error_code)>

#### <a id="method_descriptor_get_flags"></a>`[method]descriptor.get-flags: func`

Get flags associated with a descriptor.

Note: This returns similar flags to `fcntl(fd, F_GETFL)` in POSIX.

Note: This returns the value that was the `fs_flags` value returned
from `fdstat_get` in earlier versions of WASI.

##### Params

- <a id="method_descriptor_get_flags.self"></a>`self`: borrow<[`descriptor`](#descriptor)>

##### Return values

- <a id="method_descriptor_get_flags.0"></a> result<[`descriptor-flags`](#descriptor_flags), [`error-code`](#error_code)>

#### <a id="method_descriptor_get_type"></a>`[method]descriptor.get-type: func`

Get the dynamic type of a descriptor.

Note: This returns the same value as the `type` field of the `fd-stat`
returned by `stat`, `stat-at` and similar.

Note: This returns similar flags to the `st_mode & S_IFMT` value provided
by `fstat` in POSIX.

Note: This returns the value that was the `fs_filetype` value returned
from `fdstat_get` in earlier versions of WASI.

##### Params

- <a id="method_descriptor_get_type.self"></a>`self`: borrow<[`descriptor`](#descriptor)>

##### Return values

- <a id="method_descriptor_get_type.0"></a> result<[`descriptor-type`](#descriptor_type), [`error-code`](#error_code)>

#### <a id="method_descriptor_set_size"></a>`[method]descriptor.set-size: func`

Adjust the size of an open file. If this increases the file's size, the
extra bytes are filled with zeros.

Note: This was called `fd_filestat_set_size` in earlier versions of WASI.

##### Params

- <a id="method_descriptor_set_size.self"></a>`self`: borrow<[`descriptor`](#descriptor)>
- <a id="method_descriptor_set_size.size"></a>`size`: [`filesize`](#filesize)

##### Return values

- <a id="method_descriptor_set_size.0"></a> result<_, [`error-code`](#error_code)>

#### <a id="method_descriptor_set_times"></a>`[method]descriptor.set-times: func`

Adjust the timestamps of an open file or directory.

Note: This is similar to `futimens` in POSIX.

Note: This was called `fd_filestat_set_times` in earlier versions of WASI.

##### Params

- <a id="method_descriptor_set_times.self"></a>`self`: borrow<[`descriptor`](#descriptor)>
- <a id="method_descriptor_set_times.data_access_timestamp"></a>`data-access-timestamp`: [`new-timestamp`](#new_timestamp)
- <a id="method_descriptor_set_times.data_modification_timestamp"></a>`data-modification-timestamp`: [`new-timestamp`](#new_timestamp)

##### Return values

- <a id="method_descriptor_set_times.0"></a> result<_, [`error-code`](#error_code)>

#### <a id="method_descriptor_read"></a>`[method]descriptor.read: func`

Read from a descriptor, without using and updating the descriptor's offset.

This function returns a list of bytes containing the data that was
read, along with a bool which, when true, indicates that the end of the
file was reached. The returned list will contain up to `length` bytes; it
may return fewer than requested, if the end of the file is reached or
if the I/O operation is interrupted.

In the future, this may change to return a `stream<u8, error-code>`.

Note: This is similar to `pread` in POSIX.

##### Params

- <a id="method_descriptor_read.self"></a>`self`: borrow<[`descriptor`](#descriptor)>
- <a id="method_descriptor_read.length"></a>`length`: [`filesize`](#filesize)
- <a id="method_descriptor_read.offset"></a>`offset`: [`filesize`](#filesize)

##### Return values

- <a id="method_descriptor_read.0"></a> result<(list<`u8`>, `bool`), [`error-code`](#error_code)>

#### <a id="method_descriptor_write"></a>`[method]descriptor.write: func`

Write to a descriptor, without using and updating the descriptor's offset.

It is valid to write past the end of a file; the file is extended to the
extent of the write, with bytes between the previous end and the start of
the write set to zero.

In the future, this may change to take a `stream<u8, error-code>`.

Note: This is similar to `pwrite` in POSIX.

##### Params

- <a id="method_descriptor_write.self"></a>`self`: borrow<[`descriptor`](#descriptor)>
- <a id="method_descriptor_write.buffer"></a>`buffer`: list<`u8`>
- <a id="method_descriptor_write.offset"></a>`offset`: [`filesize`](#filesize)

##### Return values

- <a id="method_descriptor_write.0"></a> result<[`filesize`](#filesize), [`error-code`](#error_code)>

#### <a id="method_descriptor_read_directory"></a>`[method]descriptor.read-directory: func`

Read directory entries from a directory.

On filesystems where directories contain entries referring to themselves
and their parents, often named `.` and `..` respectively, these entries
are omitted.

This always returns a new stream which starts at the beginning of the
directory. Multiple streams may be active on the same directory, and they
do not interfere with each other.

##### Params

- <a id="method_descriptor_read_directory.self"></a>`self`: borrow<[`descriptor`](#descriptor)>

##### Return values

- <a id="method_descriptor_read_directory.0"></a> result<own<[`directory-entry-stream`](#directory_entry_stream)>, [`error-code`](#error_code)>

#### <a id="method_descriptor_sync"></a>`[method]descriptor.sync: func`

Synchronize the data and metadata of a file to disk.

This function succeeds with no effect if the file descriptor is not
opened for writing.

Note: This is similar to `fsync` in POSIX.

##### Params

- <a id="method_descriptor_sync.self"></a>`self`: borrow<[`descriptor`](#descriptor)>

##### Return values

- <a id="method_descriptor_sync.0"></a> result<_, [`error-code`](#error_code)>

#### <a id="method_descriptor_create_directory_at"></a>`[method]descriptor.create-directory-at: func`

Create a directory.

Note: This is similar to `mkdirat` in POSIX.

##### Params

- <a id="method_descriptor_create_directory_at.self"></a>`self`: borrow<[`descriptor`](#descriptor)>
- <a id="method_descriptor_create_directory_at.path"></a>`path`: `string`

##### Return values

- <a id="method_descriptor_create_directory_at.0"></a> result<_, [`error-code`](#error_code)>

#### <a id="method_descriptor_stat"></a>`[method]descriptor.stat: func`

Return the attributes of an open file or directory.

Note: This is similar to `fstat` in POSIX, except that it does not return
device and inode information. For testing whether two descriptors refer to
the same underlying filesystem object, use `is-same-object`. To obtain
additional data that can be used do determine whether a file has been
modified, use `metadata-hash`.

Note: This was called `fd_filestat_get` in earlier versions of WASI.

##### Params

- <a id="method_descriptor_stat.self"></a>`self`: borrow<[`descriptor`](#descriptor)>

##### Return values

- <a id="method_descriptor_stat.0"></a> result<[`descriptor-stat`](#descriptor_stat), [`error-code`](#error_code)>

#### <a id="method_descriptor_stat_at"></a>`[method]descriptor.stat-at: func`

Return the attributes of a file or directory.

Note: This is similar to `fstatat` in POSIX, except that it does not
return device and inode information. See the `stat` description for a
discussion of alternatives.

Note: This was called `path_filestat_get` in earlier versions of WASI.

##### Params

- <a id="method_descriptor_stat_at.self"></a>`self`: borrow<[`descriptor`](#descriptor)>
- <a id="method_descriptor_stat_at.path_flags"></a>`path-flags`: [`path-flags`](#path_flags)
- <a id="method_descriptor_stat_at.path"></a>`path`: `string`

##### Return values

- <a id="method_descriptor_stat_at.0"></a> result<[`descriptor-stat`](#descriptor_stat), [`error-code`](#error_code)>

#### <a id="method_descriptor_set_times_at"></a>`[method]descriptor.set-times-at: func`

Adjust the timestamps of a file or directory.

Note: This is similar to `utimensat` in POSIX.

Note: This was called `path_filestat_set_times` in earlier versions of
WASI.

##### Params

- <a id="method_descriptor_set_times_at.self"></a>`self`: borrow<[`descriptor`](#descriptor)>
- <a id="method_descriptor_set_times_at.path_flags"></a>`path-flags`: [`path-flags`](#path_flags)
- <a id="method_descriptor_set_times_at.path"></a>`path`: `string`
- <a id="method_descriptor_set_times_at.data_access_timestamp"></a>`data-access-timestamp`: [`new-timestamp`](#new_timestamp)
- <a id="method_descriptor_set_times_at.data_modification_timestamp"></a>`data-modification-timestamp`: [`new-timestamp`](#new_timestamp)

##### Return values

- <a id="method_descriptor_set_times_at.0"></a> result<_, [`error-code`](#error_code)>

#### <a id="method_descriptor_link_at"></a>`[method]descriptor.link-at: func`

Create a hard link.

Note: This is similar to `linkat` in POSIX.

##### Params

- <a id="method_descriptor_link_at.self"></a>`self`: borrow<[`descriptor`](#descriptor)>
- <a id="method_descriptor_link_at.old_path_flags"></a>`old-path-flags`: [`path-flags`](#path_flags)
- <a id="method_descriptor_link_at.old_path"></a>`old-path`: `string`
- <a id="method_descriptor_link_at.new_descriptor"></a>`new-descriptor`: borrow<[`descriptor`](#descriptor)>
- <a id="method_descriptor_link_at.new_path"></a>`new-path`: `string`

##### Return values

- <a id="method_descriptor_link_at.0"></a> result<_, [`error-code`](#error_code)>

#### <a id="method_descriptor_open_at"></a>`[method]descriptor.open-at: func`

Open a file or directory.

The returned descriptor is not guaranteed to be the lowest-numbered
descriptor not currently open/ it is randomized to prevent applications
from depending on making assumptions about indexes, since this is
error-prone in multi-threaded contexts. The returned descriptor is
guaranteed to be less than 2**31.

If `flags` contains `descriptor-flags::mutate-directory`, and the base
descriptor doesn't have `descriptor-flags::mutate-directory` set,
`open-at` fails with `error-code::read-only`.

If `flags` contains `write` or `mutate-directory`, or `open-flags`
contains `truncate` or `create`, and the base descriptor doesn't have
`descriptor-flags::mutate-directory` set, `open-at` fails with
`error-code::read-only`.

Note: This is similar to `openat` in POSIX.

##### Params

- <a id="method_descriptor_open_at.self"></a>`self`: borrow<[`descriptor`](#descriptor)>
- <a id="method_descriptor_open_at.path_flags"></a>`path-flags`: [`path-flags`](#path_flags)
- <a id="method_descriptor_open_at.path"></a>`path`: `string`
- <a id="method_descriptor_open_at.open_flags"></a>`open-flags`: [`open-flags`](#open_flags)
- <a id="method_descriptor_open_at.flags"></a>`flags`: [`descriptor-flags`](#descriptor_flags)

##### Return values

- <a id="method_descriptor_open_at.0"></a> result<own<[`descriptor`](#descriptor)>, [`error-code`](#error_code)>

#### <a id="method_descriptor_readlink_at"></a>`[method]descriptor.readlink-at: func`

Read the contents of a symbolic link.

If the contents contain an absolute or rooted path in the underlying
filesystem, this function fails with `error-code::not-permitted`.

Note: This is similar to `readlinkat` in POSIX.

##### Params

- <a id="method_descriptor_readlink_at.self"></a>`self`: borrow<[`descriptor`](#descriptor)>
- <a id="method_descriptor_readlink_at.path"></a>`path`: `string`

##### Return values

- <a id="method_descriptor_readlink_at.0"></a> result<`string`, [`error-code`](#error_code)>

#### <a id="method_descriptor_remove_directory_at"></a>`[method]descriptor.remove-directory-at: func`

Remove a directory.

Return `error-code::not-empty` if the directory is not empty.

Note: This is similar to `unlinkat(fd, path, AT_REMOVEDIR)` in POSIX.

##### Params

- <a id="method_descriptor_remove_directory_at.self"></a>`self`: borrow<[`descriptor`](#descriptor)>
- <a id="method_descriptor_remove_directory_at.path"></a>`path`: `string`

##### Return values

- <a id="method_descriptor_remove_directory_at.0"></a> result<_, [`error-code`](#error_code)>

#### <a id="method_descriptor_rename_at"></a>`[method]descriptor.rename-at: func`

Rename a filesystem object.

Note: This is similar to `renameat` in POSIX.

##### Params

- <a id="method_descriptor_rename_at.self"></a>`self`: borrow<[`descriptor`](#descriptor)>
- <a id="method_descriptor_rename_at.old_path"></a>`old-path`: `string`
- <a id="method_descriptor_rename_at.new_descriptor"></a>`new-descriptor`: borrow<[`descriptor`](#descriptor)>
- <a id="method_descriptor_rename_at.new_path"></a>`new-path`: `string`

##### Return values

- <a id="method_descriptor_rename_at.0"></a> result<_, [`error-code`](#error_code)>

#### <a id="method_descriptor_symlink_at"></a>`[method]descriptor.symlink-at: func`

Create a symbolic link (also known as a "symlink").

If `old-path` starts with `/`, the function fails with
`error-code::not-permitted`.

Note: This is similar to `symlinkat` in POSIX.

##### Params

- <a id="method_descriptor_symlink_at.self"></a>`self`: borrow<[`descriptor`](#descriptor)>
- <a id="method_descriptor_symlink_at.old_path"></a>`old-path`: `string`
- <a id="method_descriptor_symlink_at.new_path"></a>`new-path`: `string`

##### Return values

- <a id="method_descriptor_symlink_at.0"></a> result<_, [`error-code`](#error_code)>

#### <a id="method_descriptor_unlink_file_at"></a>`[method]descriptor.unlink-file-at: func`

Unlink a filesystem object that is not a directory.

Return `error-code::is-directory` if the path refers to a directory.
Note: This is similar to `unlinkat(fd, path, 0)` in POSIX.

##### Params

- <a id="method_descriptor_unlink_file_at.self"></a>`self`: borrow<[`descriptor`](#descriptor)>
- <a id="method_descriptor_unlink_file_at.path"></a>`path`: `string`

##### Return values

- <a id="method_descriptor_unlink_file_at.0"></a> result<_, [`error-code`](#error_code)>

#### <a id="method_descriptor_is_same_object"></a>`[method]descriptor.is-same-object: func`

Test whether two descriptors refer to the same filesystem object.

In POSIX, this corresponds to testing whether the two descriptors have the
same device (`st_dev`) and inode (`st_ino` or `d_ino`) numbers.
wasi-filesystem does not expose device and inode numbers, so this function
may be used instead.

##### Params

- <a id="method_descriptor_is_same_object.self"></a>`self`: borrow<[`descriptor`](#descriptor)>
- <a id="method_descriptor_is_same_object.other"></a>`other`: borrow<[`descriptor`](#descriptor)>

##### Return values

- <a id="method_descriptor_is_same_object.0"></a> `bool`

#### <a id="method_descriptor_metadata_hash"></a>`[method]descriptor.metadata-hash: func`

Return a hash of the metadata associated with a filesystem object referred
to by a descriptor.

This returns a hash of the last-modification timestamp and file size, and
may also include the inode number, device number, birth timestamp, and
other metadata fields that may change when the file is modified or
replaced. It may also include a secret value chosen by the
implementation and not otherwise exposed.

Implementations are encourated to provide the following properties:

- If the file is not modified or replaced, the computed hash value should
usually not change.
- If the object is modified or replaced, the computed hash value should
usually change.
- The inputs to the hash should not be easily computable from the
computed hash.

However, none of these is required.

##### Params

- <a id="method_descriptor_metadata_hash.self"></a>`self`: borrow<[`descriptor`](#descriptor)>

##### Return values

- <a id="method_descriptor_metadata_hash.0"></a> result<[`metadata-hash-value`](#metadata_hash_value), [`error-code`](#error_code)>

#### <a id="method_descriptor_metadata_hash_at"></a>`[method]descriptor.metadata-hash-at: func`

Return a hash of the metadata associated with a filesystem object referred
to by a directory descriptor and a relative path.

This performs the same hash computation as `metadata-hash`.

##### Params

- <a id="method_descriptor_metadata_hash_at.self"></a>`self`: borrow<[`descriptor`](#descriptor)>
- <a id="method_descriptor_metadata_hash_at.path_flags"></a>`path-flags`: [`path-flags`](#path_flags)
- <a id="method_descriptor_metadata_hash_at.path"></a>`path`: `string`

##### Return values

- <a id="method_descriptor_metadata_hash_at.0"></a> result<[`metadata-hash-value`](#metadata_hash_value), [`error-code`](#error_code)>

#### <a id="method_directory_entry_stream_read_directory_entry"></a>`[method]directory-entry-stream.read-directory-entry: func`

Read a single directory entry from a `directory-entry-stream`.

##### Params

- <a id="method_directory_entry_stream_read_directory_entry.self"></a>`self`: borrow<[`directory-entry-stream`](#directory_entry_stream)>

##### Return values

- <a id="method_directory_entry_stream_read_directory_entry.0"></a> result<option<[`directory-entry`](#directory_entry)>, [`error-code`](#error_code)>

#### <a id="filesystem_error_code"></a>`filesystem-error-code: func`

Attempts to extract a filesystem-related `error-code` from the stream
`error` provided.

Stream operations which return `stream-error::last-operation-failed`
have a payload with more information about the operation that failed.
This payload can be passed through to this function to see if there's
filesystem-related information about the error to return.

Note that this function is fallible because not all stream-related
errors are filesystem-related errors.

##### Params

- <a id="filesystem_error_code.err"></a>`err`: borrow<[`error`](#error)>

##### Return values

- <a id="filesystem_error_code.0"></a> option<[`error-code`](#error_code)>

## <a id="wasi_filesystem_preopens_0_2_0"></a>Import interface wasi:filesystem/preopens@0.2.0


----

### Types

#### <a id="descriptor"></a>`type descriptor`
[`descriptor`](#descriptor)
<p>
----

### Functions

#### <a id="get_directories"></a>`get-directories: func`

Return the set of preopened directories, and their path.

##### Return values

- <a id="get_directories.0"></a> list<(own<[`descriptor`](#descriptor)>, `string`)>

## <a id="wasi_cli_stdout_0_2_0"></a>Import interface wasi:cli/stdout@0.2.0


----

### Types

#### <a id="output_stream"></a>`type output-stream`
[`output-stream`](#output_stream)
<p>
----

### Functions

#### <a id="get_stdout"></a>`get-stdout: func`


##### Return values

- <a id="get_stdout.0"></a> own<[`output-stream`](#output_stream)>

## <a id="wasi_cli_stderr_0_2_0"></a>Import interface wasi:cli/stderr@0.2.0


----

### Types

#### <a id="output_stream"></a>`type output-stream`
[`output-stream`](#output_stream)
<p>
----

### Functions

#### <a id="get_stderr"></a>`get-stderr: func`


##### Return values

- <a id="get_stderr.0"></a> own<[`output-stream`](#output_stream)>

## <a id="wasi_cli_stdin_0_2_0"></a>Import interface wasi:cli/stdin@0.2.0


----

### Types

#### <a id="input_stream"></a>`type input-stream`
[`input-stream`](#input_stream)
<p>
----

### Functions

#### <a id="get_stdin"></a>`get-stdin: func`


##### Return values

- <a id="get_stdin.0"></a> own<[`input-stream`](#input_stream)>

## <a id="wasi_cli_environment_0_2_0"></a>Import interface wasi:cli/environment@0.2.0


----

### Functions

#### <a id="get_environment"></a>`get-environment: func`

Get the POSIX-style environment variables.

Each environment variable is provided as a pair of string variable names
and string value.

Morally, these are a value import, but until value imports are available
in the component model, this import function should return the same
values each time it is called.

##### Return values

- <a id="get_environment.0"></a> list<(`string`, `string`)>

#### <a id="get_arguments"></a>`get-arguments: func`

Get the POSIX-style arguments to the program.

##### Return values

- <a id="get_arguments.0"></a> list<`string`>

#### <a id="initial_cwd"></a>`initial-cwd: func`

Return a path that programs should use as their initial current working
directory, interpreting `.` as shorthand for this.

##### Return values

- <a id="initial_cwd.0"></a> option<`string`>

## <a id="wasi_cli_exit_0_2_0"></a>Import interface wasi:cli/exit@0.2.0


----

### Functions

#### <a id="exit"></a>`exit: func`

Exit the current instance and any linked instances.

##### Params

- <a id="exit.status"></a>`status`: result

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

## <a id="wasi_http_outgoing_handler_0_2_0"></a>Import interface wasi:http/outgoing-handler@0.2.0

This interface defines a handler of outgoing HTTP Requests. It should be
imported by components which wish to make HTTP Requests.

----

### Types

#### <a id="outgoing_request"></a>`type outgoing-request`
[`outgoing-request`](#outgoing_request)
<p>
#### <a id="request_options"></a>`type request-options`
[`request-options`](#request_options)
<p>
#### <a id="future_incoming_response"></a>`type future-incoming-response`
[`future-incoming-response`](#future_incoming_response)
<p>
#### <a id="error_code"></a>`type error-code`
[`error-code`](#error_code)
<p>
----

### Functions

#### <a id="handle"></a>`handle: func`

This function is invoked with an outgoing HTTP Request, and it returns
a resource `future-incoming-response` which represents an HTTP Response
which may arrive in the future.

The `options` argument accepts optional parameters for the HTTP
protocol's transport layer.

This function may return an error if the `outgoing-request` is invalid
or not allowed to be made. Otherwise, protocol errors are reported
through the `future-incoming-response`.

##### Params

- <a id="handle.request"></a>`request`: own<[`outgoing-request`](#outgoing_request)>
- <a id="handle.options"></a>`options`: option<own<[`request-options`](#request_options)>>

##### Return values

- <a id="handle.0"></a> result<own<[`future-incoming-response`](#future_incoming_response)>, [`error-code`](#error_code)>

## <a id="wasi_nn_tensor_0_2_0_rc_2024_08_19"></a>Import interface wasi:nn/tensor@0.2.0-rc-2024-08-19

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

## <a id="wasi_nn_errors_0_2_0_rc_2024_08_19"></a>Import interface wasi:nn/errors@0.2.0-rc-2024-08-19

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

## <a id="wasi_nn_inference_0_2_0_rc_2024_08_19"></a>Import interface wasi:nn/inference@0.2.0-rc-2024-08-19

An inference "session" is encapsulated by a `graph-execution-context`. This structure binds a
`graph` to input tensors before `compute`-ing an inference:

----

### Types

#### <a id="error"></a>`type error`
[`error`](#error)
<p>
#### <a id="tensor"></a>`type tensor`
[`tensor`](#tensor)
<p>
#### <a id="tensor_data"></a>`type tensor-data`
[`tensor-data`](#tensor_data)
<p>
#### <a id="graph_execution_context"></a>`resource graph-execution-context`

Bind a `graph` to the input and output tensors for an inference.

TODO: this may no longer be necessary in WIT
(https://github.com/WebAssembly/wasi-nn/issues/43)
----

### Functions

#### <a id="method_graph_execution_context_set_input"></a>`[method]graph-execution-context.set-input: func`

Define the inputs to use for inference.

##### Params

- <a id="method_graph_execution_context_set_input.self"></a>`self`: borrow<[`graph-execution-context`](#graph_execution_context)>
- <a id="method_graph_execution_context_set_input.name"></a>`name`: `string`
- <a id="method_graph_execution_context_set_input.tensor"></a>`tensor`: own<[`tensor`](#tensor)>

##### Return values

- <a id="method_graph_execution_context_set_input.0"></a> result<_, own<[`error`](#error)>>

#### <a id="method_graph_execution_context_compute"></a>`[method]graph-execution-context.compute: func`

Compute the inference on the given inputs.

Note the expected sequence of calls: `set-input`, `compute`, `get-output`. TODO: this
expectation could be removed as a part of
https://github.com/WebAssembly/wasi-nn/issues/43.

##### Params

- <a id="method_graph_execution_context_compute.self"></a>`self`: borrow<[`graph-execution-context`](#graph_execution_context)>

##### Return values

- <a id="method_graph_execution_context_compute.0"></a> result<_, own<[`error`](#error)>>

#### <a id="method_graph_execution_context_get_output"></a>`[method]graph-execution-context.get-output: func`

Extract the outputs after inference.

##### Params

- <a id="method_graph_execution_context_get_output.self"></a>`self`: borrow<[`graph-execution-context`](#graph_execution_context)>
- <a id="method_graph_execution_context_get_output.name"></a>`name`: `string`

##### Return values

- <a id="method_graph_execution_context_get_output.0"></a> result<own<[`tensor`](#tensor)>, own<[`error`](#error)>>

## <a id="wasi_nn_graph_0_2_0_rc_2024_08_19"></a>Import interface wasi:nn/graph@0.2.0-rc-2024-08-19

A `graph` is a loaded instance of a specific ML model (e.g., MobileNet) for a specific ML
framework (e.g., TensorFlow):

----

### Types

#### <a id="error"></a>`type error`
[`error`](#error)
<p>
#### <a id="tensor"></a>`type tensor`
[`tensor`](#tensor)
<p>
#### <a id="graph_execution_context"></a>`type graph-execution-context`
[`graph-execution-context`](#graph_execution_context)
<p>
#### <a id="graph"></a>`resource graph`

An execution graph for performing inference (i.e., a model).
#### <a id="graph_encoding"></a>`enum graph-encoding`

Describes the encoding of the graph. This allows the API to be implemented by various
backends that encode (i.e., serialize) their graph IR with different formats.

##### Enum Cases

- <a id="graph_encoding.openvino"></a>`openvino`
- <a id="graph_encoding.onnx"></a>`onnx`
- <a id="graph_encoding.tensorflow"></a>`tensorflow`
- <a id="graph_encoding.pytorch"></a>`pytorch`
- <a id="graph_encoding.tensorflowlite"></a>`tensorflowlite`
- <a id="graph_encoding.ggml"></a>`ggml`
- <a id="graph_encoding.autodetect"></a>`autodetect`
#### <a id="execution_target"></a>`enum execution-target`

Define where the graph should be executed.

##### Enum Cases

- <a id="execution_target.cpu"></a>`cpu`
- <a id="execution_target.gpu"></a>`gpu`
- <a id="execution_target.tpu"></a>`tpu`
#### <a id="graph_builder"></a>`type graph-builder`
[`graph-builder`](#graph_builder)
<p>The graph initialization data.

This gets bundled up into an array of buffers because implementing backends may encode their
graph IR in parts (e.g., OpenVINO stores its IR and weights separately).

----

### Functions

#### <a id="method_graph_init_execution_context"></a>`[method]graph.init-execution-context: func`


##### Params

- <a id="method_graph_init_execution_context.self"></a>`self`: borrow<[`graph`](#graph)>

##### Return values

- <a id="method_graph_init_execution_context.0"></a> result<own<[`graph-execution-context`](#graph_execution_context)>, own<[`error`](#error)>>

#### <a id="load"></a>`load: func`

Load a `graph` from an opaque sequence of bytes to use for inference.

##### Params

- <a id="load.builder"></a>`builder`: list<[`graph-builder`](#graph_builder)>
- <a id="load.encoding"></a>`encoding`: [`graph-encoding`](#graph_encoding)
- <a id="load.target"></a>`target`: [`execution-target`](#execution_target)

##### Return values

- <a id="load.0"></a> result<own<[`graph`](#graph)>, own<[`error`](#error)>>

#### <a id="load_by_name"></a>`load-by-name: func`

Load a `graph` by name.

How the host expects the names to be passed and how it stores the graphs for retrieval via
this function is **implementation-specific**. This allows hosts to choose name schemes that
range from simple to complex (e.g., URLs?) and caching mechanisms of various kinds.

##### Params

- <a id="load_by_name.name"></a>`name`: `string`

##### Return values

- <a id="load_by_name.0"></a> result<own<[`graph`](#graph)>, own<[`error`](#error)>>

## <a id="wasi_cli_run_0_2_0"></a>Export interface wasi:cli/run@0.2.0

----

### Functions

#### <a id="run"></a>`run: func`

Run the program.

##### Return values

- <a id="run.0"></a> result

