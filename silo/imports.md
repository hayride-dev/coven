# <a id="imports"></a>World imports


 - Imports:
    - interface `hayride:silo/threads@0.0.13`
    - interface `hayride:silo/process@0.0.13`

## <a id="hayride_silo_threads_0_0_13"></a>Import interface hayride:silo/threads@0.0.13


## <a id="hayride_silo_process_0_0_13"></a>Import interface hayride:silo/process@0.0.13


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

##### Return values

- <a id="spawn.0"></a> result<`s32`, [`err-no`](#err_no)>

#### <a id="wait"></a>`wait: func`


##### Params

- <a id="wait.pid"></a>`pid`: `u32`

##### Return values

- <a id="wait.0"></a> result<`u32`, [`err-no`](#err_no)>

#### <a id="kill"></a>`kill: func`


##### Params

- <a id="kill.pid"></a>`pid`: `u32`
- <a id="kill.sig"></a>`sig`: `s32`
