# <a id="imports"></a>World imports


 - Imports:
    - interface `hayride:silo/threads@0.0.54`
    - interface `hayride:silo/process@0.0.54`

## <a id="hayride_silo_threads_0_0_54"></a>Import interface hayride:silo/threads@0.0.54


----

### Types

#### <a id="err_no"></a>`type err-no`
`u32`
<p>system error numbers

#### <a id="thread_status"></a>`enum thread-status`


##### Enum Cases

- <a id="thread_status.unknown"></a>`unknown`
- <a id="thread_status.processing"></a>`processing`
- <a id="thread_status.exited"></a>`exited`
- <a id="thread_status.killed"></a>`killed`
#### <a id="thread_metadata"></a>`record thread-metadata`


##### Record Fields

- <a id="thread_metadata.id"></a>`id`: `string`
- <a id="thread_metadata.pkg"></a>`pkg`: `string`
- <a id="thread_metadata.function"></a>`function`: `string`
- <a id="thread_metadata.args"></a>`args`: list<`string`>
- <a id="thread_metadata.output"></a>`output`: list<`u8`>
- <a id="thread_metadata.status"></a>`status`: [`thread-status`](#thread_status)
#### <a id="thread"></a>`resource thread`

----

### Functions

#### <a id="method_thread_id"></a>`[method]thread.id: func`


##### Params

- <a id="method_thread_id.self"></a>`self`: borrow<[`thread`](#thread)>

##### Return values

- <a id="method_thread_id.0"></a> result<`string`, [`err-no`](#err_no)>

#### <a id="method_thread_wait"></a>`[method]thread.wait: func`


##### Params

- <a id="method_thread_wait.self"></a>`self`: borrow<[`thread`](#thread)>

##### Return values

- <a id="method_thread_wait.0"></a> result<list<`u8`>, [`err-no`](#err_no)>

#### <a id="spawn"></a>`spawn: func`


##### Params

- <a id="spawn.pkg"></a>`pkg`: `string`
- <a id="spawn.function"></a>`function`: `string`
- <a id="spawn.args"></a>`args`: list<`string`>

##### Return values

- <a id="spawn.0"></a> result<own<[`thread`](#thread)>, [`err-no`](#err_no)>

#### <a id="status"></a>`status: func`


##### Params

- <a id="status.id"></a>`id`: `string`

##### Return values

- <a id="status.0"></a> result<[`thread-metadata`](#thread_metadata), [`err-no`](#err_no)>

#### <a id="kill"></a>`kill: func`

get metadata about a single thread

##### Params

- <a id="kill.id"></a>`id`: `string`

##### Return values

- <a id="kill.0"></a> result<_, [`err-no`](#err_no)>

#### <a id="group"></a>`group: func`


##### Return values

- <a id="group.0"></a> result<list<[`thread-metadata`](#thread_metadata)>, [`err-no`](#err_no)>

## <a id="hayride_silo_process_0_0_54"></a>Import interface hayride:silo/process@0.0.54


----

### Types

#### <a id="err_no"></a>`type err-no`
`u32`
<p>system error numbers

----

### Functions

#### <a id="spawn"></a>`spawn: func`


##### Params

- <a id="spawn.path"></a>`path`: `string`
- <a id="spawn.args"></a>`args`: list<`string`>
- <a id="spawn.envs"></a>`envs`: list<(`string`, `string`)>

##### Return values

- <a id="spawn.0"></a> result<`s32`, [`err-no`](#err_no)>

#### <a id="wait"></a>`wait: func`

pid

##### Params

- <a id="wait.pid"></a>`pid`: `u32`

##### Return values

- <a id="wait.0"></a> result<`s32`, [`err-no`](#err_no)>

#### <a id="status"></a>`status: func`


##### Params

- <a id="status.pid"></a>`pid`: `u32`

##### Return values

- <a id="status.0"></a> result<`bool`, [`err-no`](#err_no)>

#### <a id="kill"></a>`kill: func`

true if running

##### Params

- <a id="kill.pid"></a>`pid`: `u32`
- <a id="kill.sig"></a>`sig`: `s32`

##### Return values

- <a id="kill.0"></a> result<`s32`, [`err-no`](#err_no)>

