# <a id="imports"></a>World imports


 - Imports:
    - interface `hayride:core/types@0.0.34`
    - interface `hayride:core/config@0.0.34`

## <a id="hayride_core_types_0_0_34"></a>Import interface hayride:core/types@0.0.34


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
#### <a id="server"></a>`record server`


##### Record Fields

- <a id="server.http"></a>`http`: [`http`](#http)
#### <a id="llm"></a>`record llm`


##### Record Fields

- <a id="llm.model"></a>`model`: `string`
#### <a id="ai"></a>`record ai`


##### Record Fields

- <a id="ai.websocket"></a>`websocket`: [`websocket`](#websocket)
- <a id="ai.http"></a>`http`: [`http`](#http)
- <a id="ai.llm"></a>`llm`: [`llm`](#llm)
#### <a id="morphs"></a>`record morphs`


##### Record Fields

- <a id="morphs.server"></a>`server`: [`server`](#server)
- <a id="morphs.ai"></a>`ai`: [`ai`](#ai)
#### <a id="config"></a>`record config`


##### Record Fields

- <a id="config.version"></a>`version`: `string`
- <a id="config.license"></a>`license`: `string`
- <a id="config.logging"></a>`logging`: [`logging`](#logging)
- <a id="config.morphs"></a>`morphs`: [`morphs`](#morphs)
#### <a id="error_code"></a>`enum error-code`


##### Enum Cases

- <a id="error_code.set_failed"></a>`set-failed`
- <a id="error_code.get_failed"></a>`get-failed`
- <a id="error_code.config_not_set"></a>`config-not-set`
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

## <a id="hayride_core_config_0_0_34"></a>Import interface hayride:core/config@0.0.34


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

