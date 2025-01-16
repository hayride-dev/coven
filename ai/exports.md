# <a id="exports"></a>World exports


 - Imports:
    - interface `wasi:io/poll@0.2.0`
    - interface `hayride:ai/types@0.0.26`
 - Exports:
    - interface `hayride:ai/agents@0.0.26`

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

## <a id="hayride_ai_types_0_0_26"></a>Import interface hayride:ai/types@0.0.26


----

### Types

#### <a id="pollable"></a>`type pollable`
[`pollable`](#pollable)
<p>
#### <a id="error_code"></a>`enum error-code`


##### Enum Cases

- <a id="error_code.invalid_argument"></a>`invalid-argument`
  <p>caller module passed an invalid argument.

- <a id="error_code.missing_capability"></a>`missing-capability`
  <p>missing capability

- <a id="error_code.runtime_error"></a>`runtime-error`
  <p>heneric Runtime Error.

- <a id="error_code.unknown"></a>`unknown`
  <p>unsupported operation.

#### <a id="error"></a>`resource error`

#### <a id="future_result"></a>`resource future-result`

#### <a id="tool"></a>`record tool`


##### Record Fields

- <a id="tool.package_id"></a>`package-id`: `string`
- <a id="tool.description"></a>`description`: `string`
#### <a id="agent"></a>`record agent`


##### Record Fields

- <a id="agent.name"></a>`name`: `string`
- <a id="agent.description"></a>`description`: `string`
- <a id="agent.capabilities"></a>`capabilities`: list<[`tool`](#tool)>
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

#### <a id="method_future_result_subscribe"></a>`[method]future-result.subscribe: func`


##### Params

- <a id="method_future_result_subscribe.self"></a>`self`: borrow<[`future-result`](#future_result)>

##### Return values

- <a id="method_future_result_subscribe.0"></a> own<[`pollable`](#pollable)>

#### <a id="method_future_result_get"></a>`[method]future-result.get: func`


##### Params

- <a id="method_future_result_get.self"></a>`self`: borrow<[`future-result`](#future_result)>

##### Return values

- <a id="method_future_result_get.0"></a> result<list<`u8`>, own<[`error`](#error)>>

## <a id="hayride_ai_agents_0_0_26"></a>Export interface hayride:ai/agents@0.0.26

----

### Types

#### <a id="agent"></a>`type agent`
[`agent`](#agent)
<p>
#### <a id="error"></a>`type error`
[`error`](#error)
<p>
#### <a id="tool"></a>`type tool`
[`tool`](#tool)
<p>
----

### Functions

#### <a id="set"></a>`set: func`


##### Params

- <a id="set.agent"></a>`agent`: [`agent`](#agent)

##### Return values

- <a id="set.0"></a> result<_, own<[`error`](#error)>>

#### <a id="get"></a>`get: func`


##### Params

- <a id="get.name"></a>`name`: `string`

##### Return values

- <a id="get.0"></a> result<[`agent`](#agent), own<[`error`](#error)>>

#### <a id="enhance"></a>`enhance: func`

enhance the agent with the given component or capabilities

##### Params

- <a id="enhance.agent"></a>`agent`: [`agent`](#agent)
- <a id="enhance.tools"></a>`tools`: list<[`tool`](#tool)>

##### Return values

- <a id="enhance.0"></a> result<_, own<[`error`](#error)>>

