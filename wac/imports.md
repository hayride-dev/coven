# <a id="imports"></a>World imports


 - Imports:
    - interface `hayride:wac/types@0.0.57`
    - interface `hayride:wac/wac@0.0.57`

## <a id="hayride_wac_types_0_0_56"></a>Import interface hayride:wac/types@0.0.57


----

### Types

#### <a id="error_code"></a>`enum error-code`


##### Enum Cases

- <a id="error_code.file_not_found"></a>`file-not-found`
- <a id="error_code.resolve_failed"></a>`resolve-failed`
- <a id="error_code.compose_failed"></a>`compose-failed`
- <a id="error_code.encode_failed"></a>`encode-failed`
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

## <a id="hayride_wac_wac_0_0_56"></a>Import interface hayride:wac/wac@0.0.57


----

### Types

#### <a id="error"></a>`type error`
[`error`](#error)
<p>
----

### Functions

#### <a id="compose"></a>`compose: func`


##### Params

- <a id="compose.contents"></a>`contents`: `string`

##### Return values

- <a id="compose.0"></a> result<list<`u8`>, own<[`error`](#error)>>

#### <a id="plug"></a>`plug: func`


##### Params

- <a id="plug.socket_pkg"></a>`socket-pkg`: `string`
- <a id="plug.plug_pkgs"></a>`plug-pkgs`: list<`string`>

##### Return values

- <a id="plug.0"></a> result<list<`u8`>, own<[`error`](#error)>>

