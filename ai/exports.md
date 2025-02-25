# <a id="exports"></a>World exports


 - Imports:
    - interface `hayride:ai/types@0.0.31`
 - Exports:
    - interface `hayride:ai/agents@0.0.31`

## <a id="hayride_ai_types_0_0_31"></a>Import interface hayride:ai/types@0.0.31


----

### Types

#### <a id="tool"></a>`record tool`


##### Record Fields

- <a id="tool.package_id"></a>`package-id`: `string`
- <a id="tool.description"></a>`description`: `string`
#### <a id="agent"></a>`record agent`


##### Record Fields

- <a id="agent.name"></a>`name`: `string`
- <a id="agent.description"></a>`description`: `string`
- <a id="agent.capabilities"></a>`capabilities`: list<[`tool`](#tool)>
## <a id="hayride_ai_agents_0_0_31"></a>Export interface hayride:ai/agents@0.0.31

----

### Types

#### <a id="agent"></a>`type agent`
[`agent`](#agent)
<p>
#### <a id="tool"></a>`type tool`
[`tool`](#tool)
<p>
#### <a id="error_code"></a>`enum error-code`


##### Enum Cases

- <a id="error_code.enhance_error"></a>`enhance-error`
  <p>generic Runtime Error.

- <a id="error_code.unknown"></a>`unknown`
  <p>unsupported operation.

#### <a id="error"></a>`resource error`

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


##### Params

- <a id="enhance.agent"></a>`agent`: [`agent`](#agent)
- <a id="enhance.tools"></a>`tools`: list<[`tool`](#tool)>

##### Return values

- <a id="enhance.0"></a> result<_, own<[`error`](#error)>>

