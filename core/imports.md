# <a id="imports"></a>World imports


 - Imports:
    - interface `hayride:core/types@0.0.45`
    - interface `hayride:core/config@0.0.45`
    - interface `hayride:ai/types@0.0.45`
    - interface `hayride:core/api@0.0.45`

## <a id="hayride_core_types_0_0_43"></a>Import interface hayride:core/types@0.0.45


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

## <a id="hayride_core_config_0_0_43"></a>Import interface hayride:core/config@0.0.45


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

## <a id="hayride_ai_types_0_0_43"></a>Import interface hayride:ai/types@0.0.45


----

### Types

#### <a id="role"></a>`enum role`


##### Enum Cases

- <a id="role.user"></a>`user`
- <a id="role.assistant"></a>`assistant`
- <a id="role.system"></a>`system`
- <a id="role.tool"></a>`tool`
- <a id="role.unknown"></a>`unknown`
#### <a id="text_content"></a>`record text-content`


##### Record Fields

- <a id="text_content.text"></a>`text`: `string`
- <a id="text_content.content_type"></a>`content-type`: `string`
#### <a id="tool_schema"></a>`record tool-schema`


##### Record Fields

- <a id="tool_schema.id"></a>`id`: `string`
- <a id="tool_schema.name"></a>`name`: `string`
- <a id="tool_schema.description"></a>`description`: `string`
- <a id="tool_schema.params_schema"></a>`params-schema`: `string`
#### <a id="tool_input"></a>`record tool-input`


##### Record Fields

- <a id="tool_input.content_type"></a>`content-type`: `string`
- <a id="tool_input.id"></a>`id`: `string`
- <a id="tool_input.name"></a>`name`: `string`
- <a id="tool_input.input"></a>`input`: `string`
#### <a id="tool_output"></a>`record tool-output`


##### Record Fields

- <a id="tool_output.content_type"></a>`content-type`: `string`
- <a id="tool_output.id"></a>`id`: `string`
- <a id="tool_output.name"></a>`name`: `string`
- <a id="tool_output.output"></a>`output`: `string`
#### <a id="content"></a>`variant content`


##### Variant Cases

- <a id="content.none"></a>`none`
- <a id="content.text"></a>`text`: [`text-content`](#text_content)
- <a id="content.tool_schema"></a>`tool-schema`: [`tool-schema`](#tool_schema)
- <a id="content.tool_input"></a>`tool-input`: [`tool-input`](#tool_input)
- <a id="content.tool_output"></a>`tool-output`: [`tool-output`](#tool_output)
#### <a id="message"></a>`record message`


##### Record Fields

- <a id="message.role"></a>`role`: [`role`](#role)
- <a id="message.content"></a>`content`: list<[`content`](#content)>
## <a id="hayride_core_api_0_0_43"></a>Import interface hayride:core/api@0.0.45


----

### Types

#### <a id="message"></a>`type message`
[`message`](#message)
<p>
#### <a id="data"></a>`variant data`


##### Variant Cases

- <a id="data.messages"></a>`messages`: list<[`message`](#message)>
#### <a id="request"></a>`record request`


##### Record Fields

- <a id="request.data"></a>`data`: [`data`](#data)
- <a id="request.metadata"></a>`metadata`: list<(`string`, `string`)>
#### <a id="response"></a>`record response`


##### Record Fields

- <a id="response.data"></a>`data`: [`data`](#data)
- <a id="response.error"></a>`error`: `string`
- <a id="response.next"></a>`next`: `string`
  <p>Cursor for pagination

- <a id="response.prev"></a>`prev`: `string`
