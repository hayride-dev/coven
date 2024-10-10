# <a id="imports"></a>World imports


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

