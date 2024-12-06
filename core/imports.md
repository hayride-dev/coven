# <a id="imports"></a>World imports


 - Imports:
    - interface `hayride:core/types@0.0.19`
    - interface `hayride:core/config@0.0.19`

## <a id="hayride_core_types_0_0_19"></a>Import interface hayride:core/types@0.0.19


----

### Types

#### <a id="logging"></a>`record logging`


##### Record Fields

- <a id="logging.enabled"></a>`enabled`: `bool`
- <a id="logging.level"></a>`level`: `string`
- <a id="logging.file"></a>`file`: `string`
#### <a id="http"></a>`record http`


##### Record Fields

- <a id="http.address"></a>`address`: `string`
#### <a id="websocket"></a>`record websocket`


##### Record Fields

- <a id="websocket.address"></a>`address`: `string`
#### <a id="runtime"></a>`record runtime`


##### Record Fields

- <a id="runtime.http"></a>`http`: [`http`](#http)
- <a id="runtime.websocket"></a>`websocket`: [`websocket`](#websocket)
#### <a id="llm"></a>`record llm`


##### Record Fields

- <a id="llm.model"></a>`model`: `string`
#### <a id="config"></a>`record config`


##### Record Fields

- <a id="config.version"></a>`version`: `string`
- <a id="config.license"></a>`license`: `string`
- <a id="config.logging"></a>`logging`: [`logging`](#logging)
- <a id="config.runtime"></a>`runtime`: [`runtime`](#runtime)
- <a id="config.llm"></a>`llm`: [`llm`](#llm)
#### <a id="error_code"></a>`enum error-code`


##### Enum Cases

- <a id="error_code.invalid_argument"></a>`invalid-argument`
  <p>Caller module passed an invalid argument.

- <a id="error_code.runtime_error"></a>`runtime-error`
  <p>Generic Runtime Error.

- <a id="error_code.unknown"></a>`unknown`
  <p>Unsupported operation.

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

## <a id="hayride_core_config_0_0_19"></a>Import interface hayride:core/config@0.0.19


----

### Types

#### <a id="config"></a>`type config`
[`config`](#config)
<p>
#### <a id="error"></a>`type error`
[`error`](#error)
<p>
----

### Functions

#### <a id="get"></a>`get: func`


##### Return values

- <a id="get.0"></a> result<[`config`](#config), own<[`error`](#error)>>

#### <a id="set"></a>`set: func`


##### Params

- <a id="set.config"></a>`config`: [`config`](#config)

##### Return values

- <a id="set.0"></a> result<_, own<[`error`](#error)>>

