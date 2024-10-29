# <a id="imports"></a>World imports


 - Imports:
    - interface `hayride:morph/errors@0.0.10`
    - interface `hayride:morph/spawn@0.0.10`

## <a id="hayride_morph_errors_0_0_10"></a>Import interface hayride:morph/errors@0.0.10


----

### Types

#### <a id="error_code"></a>`enum error-code`


##### Enum Cases

- <a id="error_code.invalid_argument"></a>`invalid-argument`
- <a id="error_code.timeout"></a>`timeout`
- <a id="error_code.runtime_error"></a>`runtime-error`
- <a id="error_code.unsupported_operation"></a>`unsupported-operation`
- <a id="error_code.too_large"></a>`too-large`
- <a id="error_code.unknown"></a>`unknown`
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

## <a id="hayride_morph_spawn_0_0_10"></a>Import interface hayride:morph/spawn@0.0.10


----

### Types

#### <a id="error"></a>`type error`
[`error`](#error)
<p>
----

### Functions

#### <a id="sync"></a>`sync: func`


##### Params

- <a id="sync.name"></a>`name`: `string`
- <a id="sync.args"></a>`args`: list<`string`>

##### Return values

- <a id="sync.0"></a> result<`string`, own<[`error`](#error)>>

