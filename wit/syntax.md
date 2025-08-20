# <a id="syntax"></a>World syntax


 - Imports:
    - interface `hayride:silo/types@0.0.63`
    - interface `hayride:silo/threads@0.0.63`
    - interface `hayride:mcp/types@0.0.63`
    - interface `hayride:ai/types@0.0.63`
    - interface `hayride:core/types@0.0.63`
    - interface `hayride:core/version@0.0.63`
    - interface `hayride:silo/process@0.0.63`
    - interface `hayride:http/types@0.0.63`
    - interface `hayride:http/config@0.0.63`
    - interface `wasi:io/error@0.2.0`
    - interface `wasi:io/poll@0.2.0`
    - interface `wasi:io/streams@0.2.0`
    - interface `hayride:socket/websocket@0.0.63`
    - interface `hayride:wac/types@0.0.63`
    - interface `hayride:wac/wac@0.0.63`
    - interface `hayride:ai/context@0.0.63`
    - interface `hayride:mcp/tools@0.0.63`
    - interface `hayride:ai/agents@0.0.63`
    - interface `hayride:ai/model@0.0.63`
    - interface `wasi:nn/tensor@0.2.0-rc-2024-10-28`
    - interface `hayride:ai/tensor-stream@0.0.63`
    - interface `wasi:nn/errors@0.2.0-rc-2024-10-28`
    - interface `hayride:ai/inference-stream@0.0.63`
    - interface `hayride:ai/graph-stream@0.0.63`
    - interface `hayride:ai/transformer@0.0.63`
    - interface `hayride:ai/rag@0.0.63`
    - interface `wasi:clocks/monotonic-clock@0.2.0`
    - interface `wasi:http/types@0.2.0`
    - interface `hayride:ai/runner@0.0.63`

## <a id="hayride_silo_types_0_0_63"></a>Import interface hayride:silo/types@0.0.63


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
## <a id="hayride_silo_threads_0_0_63"></a>Import interface hayride:silo/threads@0.0.63


----

### Types

#### <a id="err_no"></a>`type err-no`
[`err-no`](#err_no)
<p>
#### <a id="thread_metadata"></a>`type thread-metadata`
[`thread-metadata`](#thread_metadata)
<p>
#### <a id="thread_status"></a>`type thread-status`
[`thread-status`](#thread_status)
<p>
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
- <a id="spawn.envs"></a>`envs`: list<(`string`, `string`)>

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

## <a id="hayride_mcp_types_0_0_63"></a>Import interface hayride:mcp/types@0.0.63


----

### Types

#### <a id="tool_annotations"></a>`record tool-annotations`

Tool annotations provide additional metadata about a tool's behavior
https://modelcontextprotocol.io/docs/concepts/tools#available-tool-annotations

##### Record Fields

- <a id="tool_annotations.title"></a>`title`: `string`
  <p>A human-readable title for the tool, useful for UI display

- <a id="tool_annotations.read_only_hint"></a>`read-only-hint`: `bool`
  <p>If true, indicates the tool does not modify its environment
  default: false

- <a id="tool_annotations.destructive_hint"></a>`destructive-hint`: `bool`
  <p>If true, the tool may perform destructive updates
  (only meaningful when readOnlyHint is false)
  default: true

- <a id="tool_annotations.idempotent_hint"></a>`idempotent-hint`: `bool`
  <p>If true, calling the tool repeatedly with the same arguments
  has no additional effect (only meaningful when readOnlyHint is false)
  default: false

- <a id="tool_annotations.open_world_hint"></a>`open-world-hint`: `bool`
  <p>If true, the tool may interact with an “open world” of external entities
  default: true

#### <a id="tool_schema"></a>`record tool-schema`


##### Record Fields

- <a id="tool_schema.schema_type"></a>`schema-type`: `string`
- <a id="tool_schema.properties"></a>`properties`: list<(`string`, `string`)>
- <a id="tool_schema.required"></a>`required`: list<`string`>
#### <a id="tool"></a>`record tool`


##### Record Fields

- <a id="tool.name"></a>`name`: `string`
  <p>Unique identifier for the tool

- <a id="tool.title"></a>`title`: `string`
  <p>Optional human-readable name of the tool for display purposes.

- <a id="tool.description"></a>`description`: `string`
  <p>Human-readable description of functionality

- <a id="tool.input_schema"></a>`input-schema`: [`tool-schema`](#tool_schema)
  <p>JSON Schema defining expected parameters

- <a id="tool.output_schema"></a>`output-schema`: [`tool-schema`](#tool_schema)
  <p>Optional JSON Schema defining expected output structure

- <a id="tool.annotations"></a>`annotations`: [`tool-annotations`](#tool_annotations)
  <p>optional properties describing tool behavior

#### <a id="mcp_resource"></a>`record mcp-resource`


##### Record Fields

- <a id="mcp_resource.name"></a>`name`: `string`
  <p>The name of the resource

- <a id="mcp_resource.title"></a>`title`: `string`
  <p>A human-readable title for the resource, useful for UI display

- <a id="mcp_resource.description"></a>`description`: `string`
  <p>A human-readable description of the resource

- <a id="mcp_resource.uri"></a>`uri`: `string`
  <p>The URI of the resource

- <a id="mcp_resource.mime_type"></a>`mime-type`: `string`
  <p>The MIME type of the resource

- <a id="mcp_resource.size"></a>`size`: `u64`
  <p>The size of the raw resource contents in bytes

- <a id="mcp_resource.annotations"></a>`annotations`: [`tool-annotations`](#tool_annotations)
  <p>optional properties describing tool behavior

#### <a id="mcp_resource_template"></a>`record mcp-resource-template`


##### Record Fields

- <a id="mcp_resource_template.name"></a>`name`: `string`
  <p>The name of the resource template

- <a id="mcp_resource_template.title"></a>`title`: `string`
  <p>A human-readable title for the resource template, useful for UI display

- <a id="mcp_resource_template.description"></a>`description`: `string`
  <p>A human-readable description of the resource template

- <a id="mcp_resource_template.uri_template"></a>`uri-template`: `string`
  <p>A URI template (RFC 6570) that can be used to construct resource URIs

- <a id="mcp_resource_template.mime_type"></a>`mime-type`: `string`
  <p>The MIME type of the resource template

- <a id="mcp_resource_template.annotations"></a>`annotations`: [`tool-annotations`](#tool_annotations)
  <p>optional properties describing tool behavior

#### <a id="text_content"></a>`record text-content`


##### Record Fields

- <a id="text_content.content_type"></a>`content-type`: `string`
  <p>Must be "text"

- <a id="text_content.text"></a>`text`: `string`
  <p>Tool result text

#### <a id="image_content"></a>`record image-content`


##### Record Fields

- <a id="image_content.content_type"></a>`content-type`: `string`
  <p>Must be "image"

- <a id="image_content.data"></a>`data`: list<`u8`>
  <p>Base64-encoded data

- <a id="image_content.mime_type"></a>`mime-type`: `string`
  <p>MIME type of the image (e.g., "image/png")

#### <a id="audio_content"></a>`record audio-content`


##### Record Fields

- <a id="audio_content.content_type"></a>`content-type`: `string`
  <p>Must be "audio"

- <a id="audio_content.data"></a>`data`: list<`u8`>
  <p>Base64-encoded audio data

- <a id="audio_content.mime_type"></a>`mime-type`: `string`
  <p>MIME type of the audio (e.g., "audio/wav")

#### <a id="resource_link_content"></a>`record resource-link-content`


##### Record Fields

- <a id="resource_link_content.content_type"></a>`content-type`: `string`
  <p>Must be "resource_link"

- <a id="resource_link_content.uri"></a>`uri`: `string`
  <p>URI of the resource

- <a id="resource_link_content.name"></a>`name`: `string`
  <p>name of the resource

- <a id="resource_link_content.description"></a>`description`: `string`
  <p>description of the resource

- <a id="resource_link_content.mime_type"></a>`mime-type`: `string`
  <p>MIME type of the resource (e.g., "text/x-rust")

#### <a id="text_resource_contents"></a>`record text-resource-contents`


##### Record Fields

- <a id="text_resource_contents.uri"></a>`uri`: `string`
  <p>e.g. "file:///example.txt"

- <a id="text_resource_contents.name"></a>`name`: `string`
  <p>e.g. "example.txt"

- <a id="text_resource_contents.title"></a>`title`: `string`
  <p>e.g. "Example Text File"

- <a id="text_resource_contents.mime_type"></a>`mime-type`: `string`
  <p>e.g. "text/plain"

- <a id="text_resource_contents.text"></a>`text`: `string`
  <p>e.g. "Resource content"

#### <a id="blob_resource_contents"></a>`record blob-resource-contents`


##### Record Fields

- <a id="blob_resource_contents.uri"></a>`uri`: `string`
  <p>e.g. "file:///example.png"

- <a id="blob_resource_contents.name"></a>`name`: `string`
  <p>e.g. "example.png"

- <a id="blob_resource_contents.title"></a>`title`: `string`
  <p>e.g. "Example Image"

- <a id="blob_resource_contents.mime_type"></a>`mime-type`: `string`
  <p>e.g. "image/png"

- <a id="blob_resource_contents.blob"></a>`blob`: list<`u8`>
  <p>e.g. Base64-encoded binary data

#### <a id="resource_contents"></a>`variant resource-contents`

A resource can be either text or binary data.

##### Variant Cases

- <a id="resource_contents.none"></a>`none`
- <a id="resource_contents.text"></a>`text`: [`text-resource-contents`](#text_resource_contents)
- <a id="resource_contents.blob"></a>`blob`: [`blob-resource-contents`](#blob_resource_contents)
#### <a id="embedded_resource_content"></a>`record embedded-resource-content`


##### Record Fields

- <a id="embedded_resource_content.content_type"></a>`content-type`: `string`
  <p>Must be "resource"

- <a id="embedded_resource_content.resource_contents"></a>`resource-contents`: [`resource-contents`](#resource_contents)
#### <a id="content"></a>`variant content`

A content is [TextContent], [ImageContent], [AudioContent],
[ResourceLink], or [EmbeddedResource].

##### Variant Cases

- <a id="content.none"></a>`none`
- <a id="content.text"></a>`text`: [`text-content`](#text_content)
- <a id="content.image"></a>`image`: [`image-content`](#image_content)
- <a id="content.audio"></a>`audio`: [`audio-content`](#audio_content)
- <a id="content.resource_link"></a>`resource-link`: [`resource-link-content`](#resource_link_content)
- <a id="content.resource_content"></a>`resource-content`: [`embedded-resource-content`](#embedded_resource_content)
#### <a id="call_tool_params"></a>`record call-tool-params`


##### Record Fields

- <a id="call_tool_params.name"></a>`name`: `string`
  <p>The name of the tool to call

- <a id="call_tool_params.arguments"></a>`arguments`: list<(`string`, `string`)>
  <p>The arguments to pass to the tool

#### <a id="call_tool_result"></a>`record call-tool-result`


##### Record Fields

- <a id="call_tool_result.content"></a>`content`: list<[`content`](#content)>
  <p>unstructured content in the form of multiple content items

- <a id="call_tool_result.structured_content"></a>`structured-content`: list<(`string`, `string`)>
  <p>structured content in the form of a JSON string

- <a id="call_tool_result.is_error"></a>`is-error`: `bool`
  <p>true for tool execution errors

- <a id="call_tool_result.meta"></a>`meta`: list<(`string`, `string`)>
#### <a id="list_tools_result"></a>`record list-tools-result`


##### Record Fields

- <a id="list_tools_result.tools"></a>`tools`: list<[`tool`](#tool)>
- <a id="list_tools_result.next_cursor"></a>`next-cursor`: `string`
- <a id="list_tools_result.meta"></a>`meta`: list<(`string`, `string`)>
#### <a id="prompt_argument"></a>`record prompt-argument`


##### Record Fields

- <a id="prompt_argument.name"></a>`name`: `string`
  <p>The name of the argument

- <a id="prompt_argument.title"></a>`title`: `string`
  <p>A human-readable title for the argument, useful for UI display

- <a id="prompt_argument.description"></a>`description`: `string`
  <p>A human-readable description of the argument

- <a id="prompt_argument.required"></a>`required`: `bool`
  <p>Whether the argument must be provided

#### <a id="prompt"></a>`record prompt`


##### Record Fields

- <a id="prompt.name"></a>`name`: `string`
  <p>Name intended for programmatic use

- <a id="prompt.title"></a>`title`: `string`
  <p>A human-readable title for the prompt, useful for UI display

- <a id="prompt.description"></a>`description`: `string`
  <p>An optional description of what this prompt provides

- <a id="prompt.arguments"></a>`arguments`: list<[`prompt-argument`](#prompt_argument)>
  <p>A list of arguments to use for templating the prompt

- <a id="prompt.meta"></a>`meta`: list<(`string`, `string`)>
#### <a id="prompt_role"></a>`enum prompt-role`


##### Enum Cases

- <a id="prompt_role.user"></a>`user`
- <a id="prompt_role.assistant"></a>`assistant`
- <a id="prompt_role.unknown"></a>`unknown`
#### <a id="prompt_message"></a>`record prompt-message`


##### Record Fields

- <a id="prompt_message.role"></a>`role`: [`prompt-role`](#prompt_role)
- <a id="prompt_message.content"></a>`content`: [`content`](#content)
#### <a id="get_prompt_params"></a>`record get-prompt-params`


##### Record Fields

- <a id="get_prompt_params.name"></a>`name`: `string`
  <p>The name of the prompt or prompt template

- <a id="get_prompt_params.arguments"></a>`arguments`: list<(`string`, `string`)>
  <p>Arguments to use for templating the prompt

#### <a id="get_prompt_result"></a>`record get-prompt-result`


##### Record Fields

- <a id="get_prompt_result.description"></a>`description`: `string`
- <a id="get_prompt_result.messages"></a>`messages`: list<[`prompt-message`](#prompt_message)>
- <a id="get_prompt_result.meta"></a>`meta`: list<(`string`, `string`)>
#### <a id="list_prompts_result"></a>`record list-prompts-result`


##### Record Fields

- <a id="list_prompts_result.prompts"></a>`prompts`: list<[`prompt`](#prompt)>
- <a id="list_prompts_result.next_cursor"></a>`next-cursor`: `string`
- <a id="list_prompts_result.meta"></a>`meta`: list<(`string`, `string`)>
#### <a id="read_resource_params"></a>`record read-resource-params`


##### Record Fields

- <a id="read_resource_params.uri"></a>`uri`: `string`
#### <a id="read_resource_result"></a>`record read-resource-result`


##### Record Fields

- <a id="read_resource_result.contents"></a>`contents`: list<[`resource-contents`](#resource_contents)>
  <p>The resource contents

#### <a id="list_resources_result"></a>`record list-resources-result`


##### Record Fields

- <a id="list_resources_result.resources"></a>`resources`: list<[`mcp-resource`](#mcp_resource)>
- <a id="list_resources_result.next_cursor"></a>`next-cursor`: `string`
- <a id="list_resources_result.meta"></a>`meta`: list<(`string`, `string`)>
#### <a id="list_resource_templates_result"></a>`record list-resource-templates-result`


##### Record Fields

- <a id="list_resource_templates_result.templates"></a>`templates`: list<[`mcp-resource-template`](#mcp_resource_template)>
- <a id="list_resource_templates_result.next_cursor"></a>`next-cursor`: `string`
- <a id="list_resource_templates_result.meta"></a>`meta`: list<(`string`, `string`)>
## <a id="hayride_ai_types_0_0_63"></a>Import interface hayride:ai/types@0.0.63


----

### Types

#### <a id="tool"></a>`type tool`
[`tool`](#tool)
<p>
#### <a id="call_tool_params"></a>`type call-tool-params`
[`call-tool-params`](#call_tool_params)
<p>
#### <a id="call_tool_result"></a>`type call-tool-result`
[`call-tool-result`](#call_tool_result)
<p>
#### <a id="role"></a>`enum role`


##### Enum Cases

- <a id="role.user"></a>`user`
- <a id="role.assistant"></a>`assistant`
- <a id="role.system"></a>`system`
- <a id="role.tool"></a>`tool`
- <a id="role.unknown"></a>`unknown`
#### <a id="message_content"></a>`variant message-content`


##### Variant Cases

- <a id="message_content.none"></a>`none`
- <a id="message_content.text"></a>`text`: `string`
- <a id="message_content.blob"></a>`blob`: list<`u8`>
- <a id="message_content.tools"></a>`tools`: list<[`tool`](#tool)>
- <a id="message_content.tool_input"></a>`tool-input`: [`call-tool-params`](#call_tool_params)
- <a id="message_content.tool_output"></a>`tool-output`: [`call-tool-result`](#call_tool_result)
#### <a id="message"></a>`record message`


##### Record Fields

- <a id="message.role"></a>`role`: [`role`](#role)
- <a id="message.content"></a>`content`: list<[`message-content`](#message_content)>
- <a id="message.final"></a>`final`: `bool`
## <a id="hayride_core_types_0_0_63"></a>Import interface hayride:core/types@0.0.63


----

### Types

#### <a id="thread_metadata"></a>`type thread-metadata`
[`thread-metadata`](#thread_metadata)
<p>
#### <a id="thread_status"></a>`type thread-status`
[`thread-status`](#thread_status)
<p>
#### <a id="message"></a>`type message`
[`message`](#message)
<p>
#### <a id="cast"></a>`record cast`


##### Record Fields

- <a id="cast.name"></a>`name`: `string`
- <a id="cast.function"></a>`function`: `string`
- <a id="cast.args"></a>`args`: list<`string`>
- <a id="cast.envs"></a>`envs`: list<(`string`, `string`)>
#### <a id="generate"></a>`record generate`


##### Record Fields

- <a id="generate.model"></a>`model`: `string`
- <a id="generate.system"></a>`system`: `string`
- <a id="generate.messages"></a>`messages`: list<[`message`](#message)>
#### <a id="request_data"></a>`variant request-data`


##### Variant Cases

- <a id="request_data.unknown"></a>`unknown`
- <a id="request_data.cast"></a>`cast`: [`cast`](#cast)
- <a id="request_data.session_id"></a>`session-id`: `string`
- <a id="request_data.generate"></a>`generate`: [`generate`](#generate)
#### <a id="response_data"></a>`variant response-data`


##### Variant Cases

- <a id="response_data.unknown"></a>`unknown`
- <a id="response_data.sessions"></a>`sessions`: list<[`thread-metadata`](#thread_metadata)>
- <a id="response_data.session_id"></a>`session-id`: `string`
- <a id="response_data.session_status"></a>`session-status`: [`thread-status`](#thread_status)
- <a id="response_data.messages"></a>`messages`: list<[`message`](#message)>
- <a id="response_data.path"></a>`path`: `string`
- <a id="response_data.paths"></a>`paths`: list<`string`>
- <a id="response_data.version"></a>`version`: `string`
#### <a id="request"></a>`record request`


##### Record Fields

- <a id="request.data"></a>`data`: [`request-data`](#request_data)
- <a id="request.metadata"></a>`metadata`: list<(`string`, `string`)>
#### <a id="response"></a>`record response`


##### Record Fields

- <a id="response.data"></a>`data`: [`response-data`](#response_data)
- <a id="response.error"></a>`error`: `string`
- <a id="response.next"></a>`next`: `string`
  <p>Cursor for pagination

- <a id="response.prev"></a>`prev`: `string`
## <a id="hayride_core_version_0_0_63"></a>Import interface hayride:core/version@0.0.63


----

### Types

#### <a id="error_code"></a>`enum error-code`


##### Enum Cases

- <a id="error_code.get_version_failed"></a>`get-version-failed`
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

#### <a id="latest"></a>`latest: func`


##### Return values

- <a id="latest.0"></a> result<`string`, own<[`error`](#error)>>

## <a id="hayride_silo_process_0_0_63"></a>Import interface hayride:silo/process@0.0.63


----

### Types

#### <a id="err_no"></a>`type err-no`
[`err-no`](#err_no)
<p>
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

## <a id="hayride_http_types_0_0_63"></a>Import interface hayride:http/types@0.0.63


----

### Types

#### <a id="error_code"></a>`enum error-code`


##### Enum Cases

- <a id="error_code.invalid"></a>`invalid`
- <a id="error_code.not_found"></a>`not-found`
- <a id="error_code.unknown"></a>`unknown`
#### <a id="server_config"></a>`record server-config`


##### Record Fields

- <a id="server_config.address"></a>`address`: `string`
- <a id="server_config.read_timeout"></a>`read-timeout`: `u32`
- <a id="server_config.write_timeout"></a>`write-timeout`: `u32`
- <a id="server_config.max_header_bytes"></a>`max-header-bytes`: `u32`
## <a id="hayride_http_config_0_0_63"></a>Import interface hayride:http/config@0.0.63


----

### Types

#### <a id="server_config"></a>`type server-config`
[`server-config`](#server_config)
<p>
#### <a id="error_code"></a>`type error-code`
[`error-code`](#error_code)
<p>
#### <a id="error"></a>`resource error`

----

### Functions

#### <a id="method_error_code"></a>`[method]error.code: func`


##### Params

- <a id="method_error_code.self"></a>`self`: borrow<[`error`](#error)>

##### Return values

- <a id="method_error_code.0"></a> [`error-code`](#error_code)

#### <a id="method_error_data"></a>`[method]error.data: func`


##### Params

- <a id="method_error_data.self"></a>`self`: borrow<[`error`](#error)>

##### Return values

- <a id="method_error_data.0"></a> `string`

#### <a id="get"></a>`get: func`


##### Return values

- <a id="get.0"></a> result<[`server-config`](#server_config), own<[`error`](#error)>>

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

## <a id="hayride_socket_websocket_0_0_63"></a>Import interface hayride:socket/websocket@0.0.63


----

### Types

#### <a id="input_stream"></a>`type input-stream`
[`input-stream`](#input_stream)
<p>
#### <a id="output_stream"></a>`type output-stream`
[`output-stream`](#output_stream)
<p>
----

### Functions

#### <a id="handle"></a>`handle: func`


##### Params

- <a id="handle.input"></a>`input`: own<[`input-stream`](#input_stream)>
- <a id="handle.output"></a>`output`: own<[`output-stream`](#output_stream)>

## <a id="hayride_wac_types_0_0_63"></a>Import interface hayride:wac/types@0.0.63


----

### Types

#### <a id="error_code"></a>`enum error-code`


##### Enum Cases

- <a id="error_code.file_not_found"></a>`file-not-found`
- <a id="error_code.resolve_failed"></a>`resolve-failed`
- <a id="error_code.compose_failed"></a>`compose-failed`
- <a id="error_code.encode_failed"></a>`encode-failed`
- <a id="error_code.unknown"></a>`unknown`
## <a id="hayride_wac_wac_0_0_63"></a>Import interface hayride:wac/wac@0.0.63


----

### Types

#### <a id="error_code"></a>`type error-code`
[`error-code`](#error_code)
<p>
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

## <a id="hayride_ai_context_0_0_63"></a>Import interface hayride:ai/context@0.0.63


----

### Types

#### <a id="message"></a>`type message`
[`message`](#message)
<p>
#### <a id="error_code"></a>`enum error-code`


##### Enum Cases

- <a id="error_code.unexpected_message_type"></a>`unexpected-message-type`
- <a id="error_code.push_error"></a>`push-error`
- <a id="error_code.message_not_found"></a>`message-not-found`
- <a id="error_code.unknown"></a>`unknown`
#### <a id="error"></a>`resource error`

#### <a id="context"></a>`resource context`

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

#### <a id="constructor_context"></a>`[constructor]context: func`


##### Return values

- <a id="constructor_context.0"></a> own<[`context`](#context)>

#### <a id="method_context_push"></a>`[method]context.push: func`


##### Params

- <a id="method_context_push.self"></a>`self`: borrow<[`context`](#context)>
- <a id="method_context_push.msg"></a>`msg`: [`message`](#message)

##### Return values

- <a id="method_context_push.0"></a> result<_, own<[`error`](#error)>>

#### <a id="method_context_messages"></a>`[method]context.messages: func`


##### Params

- <a id="method_context_messages.self"></a>`self`: borrow<[`context`](#context)>

##### Return values

- <a id="method_context_messages.0"></a> result<list<[`message`](#message)>, own<[`error`](#error)>>

## <a id="hayride_mcp_tools_0_0_63"></a>Import interface hayride:mcp/tools@0.0.63


----

### Types

#### <a id="call_tool_params"></a>`type call-tool-params`
[`call-tool-params`](#call_tool_params)
<p>
#### <a id="call_tool_result"></a>`type call-tool-result`
[`call-tool-result`](#call_tool_result)
<p>
#### <a id="list_tools_result"></a>`type list-tools-result`
[`list-tools-result`](#list_tools_result)
<p>
#### <a id="error_code"></a>`enum error-code`


##### Enum Cases

- <a id="error_code.tool_call_failed"></a>`tool-call-failed`
- <a id="error_code.tool_not_found"></a>`tool-not-found`
- <a id="error_code.unknown"></a>`unknown`
#### <a id="error"></a>`resource error`

#### <a id="tools"></a>`resource tools`

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

#### <a id="constructor_tools"></a>`[constructor]tools: func`


##### Return values

- <a id="constructor_tools.0"></a> own<[`tools`](#tools)>

#### <a id="method_tools_list_tools"></a>`[method]tools.list-tools: func`


##### Params

- <a id="method_tools_list_tools.self"></a>`self`: borrow<[`tools`](#tools)>
- <a id="method_tools_list_tools.cursor"></a>`cursor`: `string`

##### Return values

- <a id="method_tools_list_tools.0"></a> result<[`list-tools-result`](#list_tools_result), own<[`error`](#error)>>

#### <a id="method_tools_call_tool"></a>`[method]tools.call-tool: func`


##### Params

- <a id="method_tools_call_tool.self"></a>`self`: borrow<[`tools`](#tools)>
- <a id="method_tools_call_tool.params"></a>`params`: [`call-tool-params`](#call_tool_params)

##### Return values

- <a id="method_tools_call_tool.0"></a> result<[`call-tool-result`](#call_tool_result), own<[`error`](#error)>>

## <a id="hayride_ai_agents_0_0_63"></a>Import interface hayride:ai/agents@0.0.63


----

### Types

#### <a id="message"></a>`type message`
[`message`](#message)
<p>
#### <a id="context"></a>`type context`
[`context`](#context)
<p>
#### <a id="tools"></a>`type tools`
[`tools`](#tools)
<p>
#### <a id="tool"></a>`type tool`
[`tool`](#tool)
<p>
#### <a id="call_tool_params"></a>`type call-tool-params`
[`call-tool-params`](#call_tool_params)
<p>
#### <a id="call_tool_result"></a>`type call-tool-result`
[`call-tool-result`](#call_tool_result)
<p>
#### <a id="error_code"></a>`enum error-code`


##### Enum Cases

- <a id="error_code.capabilities_error"></a>`capabilities-error`
- <a id="error_code.context_error"></a>`context-error`
- <a id="error_code.push_error"></a>`push-error`
- <a id="error_code.execute_error"></a>`execute-error`
- <a id="error_code.unknown"></a>`unknown`
#### <a id="error"></a>`resource error`

#### <a id="agent"></a>`resource agent`

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

#### <a id="constructor_agent"></a>`[constructor]agent: func`


##### Params

- <a id="constructor_agent.name"></a>`name`: `string`
- <a id="constructor_agent.instruction"></a>`instruction`: `string`
- <a id="constructor_agent.tools"></a>`tools`: option<own<[`tools`](#tools)>>
- <a id="constructor_agent.context"></a>`context`: option<own<[`context`](#context)>>

##### Return values

- <a id="constructor_agent.0"></a> own<[`agent`](#agent)>

#### <a id="method_agent_name"></a>`[method]agent.name: func`


##### Params

- <a id="method_agent_name.self"></a>`self`: borrow<[`agent`](#agent)>

##### Return values

- <a id="method_agent_name.0"></a> `string`

#### <a id="method_agent_instruction"></a>`[method]agent.instruction: func`


##### Params

- <a id="method_agent_instruction.self"></a>`self`: borrow<[`agent`](#agent)>

##### Return values

- <a id="method_agent_instruction.0"></a> `string`

#### <a id="method_agent_capabilities"></a>`[method]agent.capabilities: func`


##### Params

- <a id="method_agent_capabilities.self"></a>`self`: borrow<[`agent`](#agent)>

##### Return values

- <a id="method_agent_capabilities.0"></a> result<list<[`tool`](#tool)>, own<[`error`](#error)>>

#### <a id="method_agent_context"></a>`[method]agent.context: func`


##### Params

- <a id="method_agent_context.self"></a>`self`: borrow<[`agent`](#agent)>

##### Return values

- <a id="method_agent_context.0"></a> result<list<[`message`](#message)>, own<[`error`](#error)>>

#### <a id="method_agent_push"></a>`[method]agent.push: func`


##### Params

- <a id="method_agent_push.self"></a>`self`: borrow<[`agent`](#agent)>
- <a id="method_agent_push.msg"></a>`msg`: [`message`](#message)

##### Return values

- <a id="method_agent_push.0"></a> result<_, own<[`error`](#error)>>

#### <a id="method_agent_execute"></a>`[method]agent.execute: func`


##### Params

- <a id="method_agent_execute.self"></a>`self`: borrow<[`agent`](#agent)>
- <a id="method_agent_execute.params"></a>`params`: [`call-tool-params`](#call_tool_params)

##### Return values

- <a id="method_agent_execute.0"></a> result<[`call-tool-result`](#call_tool_result), own<[`error`](#error)>>

## <a id="hayride_ai_model_0_0_63"></a>Import interface hayride:ai/model@0.0.63


----

### Types

#### <a id="message"></a>`type message`
[`message`](#message)
<p>
#### <a id="error_code"></a>`enum error-code`


##### Enum Cases

- <a id="error_code.context_error"></a>`context-error`
- <a id="error_code.context_encode"></a>`context-encode`
- <a id="error_code.context_decode"></a>`context-decode`
- <a id="error_code.compute_error"></a>`compute-error`
- <a id="error_code.partial_decode"></a>`partial-decode`
- <a id="error_code.unknown"></a>`unknown`
#### <a id="error"></a>`resource error`

#### <a id="format"></a>`resource format`

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

#### <a id="constructor_format"></a>`[constructor]format: func`


##### Return values

- <a id="constructor_format.0"></a> own<[`format`](#format)>

#### <a id="method_format_encode"></a>`[method]format.encode: func`


##### Params

- <a id="method_format_encode.self"></a>`self`: borrow<[`format`](#format)>
- <a id="method_format_encode.messages"></a>`messages`: list<[`message`](#message)>

##### Return values

- <a id="method_format_encode.0"></a> result<list<`u8`>, own<[`error`](#error)>>

#### <a id="method_format_decode"></a>`[method]format.decode: func`


##### Params

- <a id="method_format_decode.self"></a>`self`: borrow<[`format`](#format)>
- <a id="method_format_decode.raw"></a>`raw`: list<`u8`>

##### Return values

- <a id="method_format_decode.0"></a> result<[`message`](#message), own<[`error`](#error)>>

## <a id="wasi_nn_tensor_0_2_0_rc_2024_10_28"></a>Import interface wasi:nn/tensor@0.2.0-rc-2024-10-28

All inputs and outputs to an ML inference are represented as `tensor`s.

----

### Types

#### <a id="tensor_dimensions"></a>`type tensor-dimensions`
[`tensor-dimensions`](#tensor_dimensions)
<p>The dimensions of a tensor.

The array length matches the tensor rank and each element in the array describes the size of
each dimension

#### <a id="tensor_type"></a>`enum tensor-type`

The type of the elements in a tensor.

##### Enum Cases

- <a id="tensor_type.fp16"></a>`FP16`
- <a id="tensor_type.fp32"></a>`FP32`
- <a id="tensor_type.fp64"></a>`FP64`
- <a id="tensor_type.bf16"></a>`BF16`
- <a id="tensor_type.u8"></a>`U8`
- <a id="tensor_type.i32"></a>`I32`
- <a id="tensor_type.i64"></a>`I64`
#### <a id="tensor_data"></a>`type tensor-data`
[`tensor-data`](#tensor_data)
<p>The tensor data.

Initially conceived as a sparse representation, each empty cell would be filled with zeros
and the array length must match the product of all of the dimensions and the number of bytes
in the type (e.g., a 2x2 tensor with 4-byte f32 elements would have a data array of length
16). Naturally, this representation requires some knowledge of how to lay out data in
memory--e.g., using row-major ordering--and could perhaps be improved.

#### <a id="tensor"></a>`resource tensor`

----

### Functions

#### <a id="constructor_tensor"></a>`[constructor]tensor: func`


##### Params

- <a id="constructor_tensor.dimensions"></a>`dimensions`: [`tensor-dimensions`](#tensor_dimensions)
- <a id="constructor_tensor.ty"></a>`ty`: [`tensor-type`](#tensor_type)
- <a id="constructor_tensor.data"></a>`data`: [`tensor-data`](#tensor_data)

##### Return values

- <a id="constructor_tensor.0"></a> own<[`tensor`](#tensor)>

#### <a id="method_tensor_dimensions"></a>`[method]tensor.dimensions: func`

Describe the size of the tensor (e.g., 2x2x2x2 -> [2, 2, 2, 2]). To represent a tensor
containing a single value, use `[1]` for the tensor dimensions.

##### Params

- <a id="method_tensor_dimensions.self"></a>`self`: borrow<[`tensor`](#tensor)>

##### Return values

- <a id="method_tensor_dimensions.0"></a> [`tensor-dimensions`](#tensor_dimensions)

#### <a id="method_tensor_ty"></a>`[method]tensor.ty: func`

Describe the type of element in the tensor (e.g., `f32`).

##### Params

- <a id="method_tensor_ty.self"></a>`self`: borrow<[`tensor`](#tensor)>

##### Return values

- <a id="method_tensor_ty.0"></a> [`tensor-type`](#tensor_type)

#### <a id="method_tensor_data"></a>`[method]tensor.data: func`

Return the tensor data.

##### Params

- <a id="method_tensor_data.self"></a>`self`: borrow<[`tensor`](#tensor)>

##### Return values

- <a id="method_tensor_data.0"></a> [`tensor-data`](#tensor_data)

## <a id="hayride_ai_tensor_stream_0_0_63"></a>Import interface hayride:ai/tensor-stream@0.0.63

This interface defines a stream of tensors. The stream is a sequence of tensors.

----

### Types

#### <a id="tensor_data"></a>`type tensor-data`
[`tensor-data`](#tensor_data)
<p>
#### <a id="tensor_dimensions"></a>`type tensor-dimensions`
[`tensor-dimensions`](#tensor_dimensions)
<p>
#### <a id="tensor_type"></a>`type tensor-type`
[`tensor-type`](#tensor_type)
<p>
#### <a id="pollable"></a>`type pollable`
[`pollable`](#pollable)
<p>
#### <a id="stream_error"></a>`type stream-error`
[`stream-error`](#stream_error)
<p>
#### <a id="tensor_stream"></a>`resource tensor-stream`

----

### Functions

#### <a id="constructor_tensor_stream"></a>`[constructor]tensor-stream: func`


##### Params

- <a id="constructor_tensor_stream.dimensions"></a>`dimensions`: [`tensor-dimensions`](#tensor_dimensions)
- <a id="constructor_tensor_stream.ty"></a>`ty`: [`tensor-type`](#tensor_type)
- <a id="constructor_tensor_stream.data"></a>`data`: [`tensor-data`](#tensor_data)

##### Return values

- <a id="constructor_tensor_stream.0"></a> own<[`tensor-stream`](#tensor_stream)>

#### <a id="method_tensor_stream_dimensions"></a>`[method]tensor-stream.dimensions: func`

Describe the size of the tensor (e.g., 2x2x2x2 -> [2, 2, 2, 2]). To represent a tensor
containing a single value, use `[1]` for the tensor dimensions.

##### Params

- <a id="method_tensor_stream_dimensions.self"></a>`self`: borrow<[`tensor-stream`](#tensor_stream)>

##### Return values

- <a id="method_tensor_stream_dimensions.0"></a> [`tensor-dimensions`](#tensor_dimensions)

#### <a id="method_tensor_stream_ty"></a>`[method]tensor-stream.ty: func`

Describe the type of element in the tensor (e.g., `f32`).

##### Params

- <a id="method_tensor_stream_ty.self"></a>`self`: borrow<[`tensor-stream`](#tensor_stream)>

##### Return values

- <a id="method_tensor_stream_ty.0"></a> [`tensor-type`](#tensor_type)

#### <a id="method_tensor_stream_read"></a>`[method]tensor-stream.read: func`

Read up to `len` bytes from the stream.

##### Params

- <a id="method_tensor_stream_read.self"></a>`self`: borrow<[`tensor-stream`](#tensor_stream)>
- <a id="method_tensor_stream_read.len"></a>`len`: `u64`

##### Return values

- <a id="method_tensor_stream_read.0"></a> result<[`tensor-data`](#tensor_data), [`stream-error`](#stream_error)>

#### <a id="method_tensor_stream_subscribe"></a>`[method]tensor-stream.subscribe: func`


##### Params

- <a id="method_tensor_stream_subscribe.self"></a>`self`: borrow<[`tensor-stream`](#tensor_stream)>

##### Return values

- <a id="method_tensor_stream_subscribe.0"></a> own<[`pollable`](#pollable)>

## <a id="wasi_nn_errors_0_2_0_rc_2024_10_28"></a>Import interface wasi:nn/errors@0.2.0-rc-2024-10-28

TODO: create function-specific errors (https://github.com/WebAssembly/wasi-nn/issues/42)

----

### Types

#### <a id="error_code"></a>`enum error-code`


##### Enum Cases

- <a id="error_code.invalid_argument"></a>`invalid-argument`
  <p>Caller module passed an invalid argument.

- <a id="error_code.invalid_encoding"></a>`invalid-encoding`
  <p>Invalid encoding.

- <a id="error_code.timeout"></a>`timeout`
  <p>The operation timed out.

- <a id="error_code.runtime_error"></a>`runtime-error`
  <p>Runtime Error.

- <a id="error_code.unsupported_operation"></a>`unsupported-operation`
  <p>Unsupported operation.

- <a id="error_code.too_large"></a>`too-large`
  <p>Graph is too large.

- <a id="error_code.not_found"></a>`not-found`
  <p>Graph not found.

- <a id="error_code.security"></a>`security`
  <p>The operation is insecure or has insufficient privilege to be performed.
  e.g., cannot access a hardware feature requested

- <a id="error_code.unknown"></a>`unknown`
  <p>The operation failed for an unspecified reason.

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

## <a id="hayride_ai_inference_stream_0_0_63"></a>Import interface hayride:ai/inference-stream@0.0.63


----

### Types

#### <a id="error"></a>`type error`
[`error`](#error)
<p>
#### <a id="tensor"></a>`type tensor`
[`tensor`](#tensor)
<p>
#### <a id="tensor_stream"></a>`type tensor-stream`
[`tensor-stream`](#tensor_stream)
<p>
#### <a id="named_tensor"></a>`tuple named-tensor`

Identify a tensor by name; this is necessary to associate tensors to
graph inputs and outputs.

##### Tuple Fields

- <a id="named_tensor.0"></a>`0`: `string`
- <a id="named_tensor.1"></a>`1`: own<[`tensor`](#tensor)>
#### <a id="named_tensor_stream"></a>`tuple named-tensor-stream`


##### Tuple Fields

- <a id="named_tensor_stream.0"></a>`0`: `string`
- <a id="named_tensor_stream.1"></a>`1`: own<[`tensor-stream`](#tensor_stream)>
#### <a id="graph_execution_context_stream"></a>`resource graph-execution-context-stream`

----

### Functions

#### <a id="method_graph_execution_context_stream_compute"></a>`[method]graph-execution-context-stream.compute: func`

Compute the inference on the given inputs.

##### Params

- <a id="method_graph_execution_context_stream_compute.self"></a>`self`: borrow<[`graph-execution-context-stream`](#graph_execution_context_stream)>
- <a id="method_graph_execution_context_stream_compute.inputs"></a>`inputs`: list<[`named-tensor`](#named_tensor)>

##### Return values

- <a id="method_graph_execution_context_stream_compute.0"></a> result<[`named-tensor-stream`](#named_tensor_stream), own<[`error`](#error)>>

## <a id="hayride_ai_graph_stream_0_0_63"></a>Import interface hayride:ai/graph-stream@0.0.63


----

### Types

#### <a id="error"></a>`type error`
[`error`](#error)
<p>
#### <a id="tensor"></a>`type tensor`
[`tensor`](#tensor)
<p>
#### <a id="graph_execution_context_stream"></a>`type graph-execution-context-stream`
[`graph-execution-context-stream`](#graph_execution_context_stream)
<p>
#### <a id="graph_stream"></a>`resource graph-stream`

----

### Functions

#### <a id="method_graph_stream_init_execution_context_stream"></a>`[method]graph-stream.init-execution-context-stream: func`


##### Params

- <a id="method_graph_stream_init_execution_context_stream.self"></a>`self`: borrow<[`graph-stream`](#graph_stream)>

##### Return values

- <a id="method_graph_stream_init_execution_context_stream.0"></a> result<own<[`graph-execution-context-stream`](#graph_execution_context_stream)>, own<[`error`](#error)>>

#### <a id="load_by_name"></a>`load-by-name: func`

Load a `graph` by name.

How the host expects the names to be passed and how it stores the graphs for retrieval via
this function is **implementation-specific**. This allows hosts to choose name schemes that
range from simple to complex (e.g., URLs?) and caching mechanisms of various kinds.

##### Params

- <a id="load_by_name.name"></a>`name`: `string`

##### Return values

- <a id="load_by_name.0"></a> result<own<[`graph-stream`](#graph_stream)>, own<[`error`](#error)>>

## <a id="hayride_ai_transformer_0_0_63"></a>Import interface hayride:ai/transformer@0.0.63


----

### Types

#### <a id="embedding_type"></a>`enum embedding-type`


##### Enum Cases

- <a id="embedding_type.sentence"></a>`sentence`
#### <a id="transformer"></a>`resource transformer`

----

### Functions

#### <a id="constructor_transformer"></a>`[constructor]transformer: func`


##### Params

- <a id="constructor_transformer.embedding"></a>`embedding`: [`embedding-type`](#embedding_type)
- <a id="constructor_transformer.model"></a>`model`: `string`
- <a id="constructor_transformer.data_column"></a>`data-column`: `string`
- <a id="constructor_transformer.vector_column"></a>`vector-column`: `string`

##### Return values

- <a id="constructor_transformer.0"></a> own<[`transformer`](#transformer)>

#### <a id="method_transformer_embedding"></a>`[method]transformer.embedding: func`


##### Params

- <a id="method_transformer_embedding.self"></a>`self`: borrow<[`transformer`](#transformer)>

##### Return values

- <a id="method_transformer_embedding.0"></a> [`embedding-type`](#embedding_type)

#### <a id="method_transformer_model"></a>`[method]transformer.model: func`


##### Params

- <a id="method_transformer_model.self"></a>`self`: borrow<[`transformer`](#transformer)>

##### Return values

- <a id="method_transformer_model.0"></a> `string`

#### <a id="method_transformer_data_column"></a>`[method]transformer.data-column: func`


##### Params

- <a id="method_transformer_data_column.self"></a>`self`: borrow<[`transformer`](#transformer)>

##### Return values

- <a id="method_transformer_data_column.0"></a> `string`

#### <a id="method_transformer_vector_column"></a>`[method]transformer.vector-column: func`


##### Params

- <a id="method_transformer_vector_column.self"></a>`self`: borrow<[`transformer`](#transformer)>

##### Return values

- <a id="method_transformer_vector_column.0"></a> `string`

## <a id="hayride_ai_rag_0_0_63"></a>Import interface hayride:ai/rag@0.0.63


----

### Types

#### <a id="transformer"></a>`type transformer`
[`transformer`](#transformer)
<p>
#### <a id="error_code"></a>`enum error-code`


##### Enum Cases

- <a id="error_code.connection_failed"></a>`connection-failed`
- <a id="error_code.create_table_failed"></a>`create-table-failed`
- <a id="error_code.query_failed"></a>`query-failed`
- <a id="error_code.embed_failed"></a>`embed-failed`
- <a id="error_code.register_failed"></a>`register-failed`
- <a id="error_code.missing_table"></a>`missing-table`
- <a id="error_code.invalid_option"></a>`invalid-option`
- <a id="error_code.not_enabled"></a>`not-enabled`
- <a id="error_code.unknown"></a>`unknown`
#### <a id="error"></a>`resource error`

#### <a id="rag_option"></a>`tuple rag-option`


##### Tuple Fields

- <a id="rag_option.0"></a>`0`: `string`
- <a id="rag_option.1"></a>`1`: `string`
#### <a id="connection"></a>`resource connection`

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

#### <a id="method_connection_register"></a>`[method]connection.register: func`


##### Params

- <a id="method_connection_register.self"></a>`self`: borrow<[`connection`](#connection)>
- <a id="method_connection_register.transformer"></a>`transformer`: own<[`transformer`](#transformer)>

##### Return values

- <a id="method_connection_register.0"></a> result<_, own<[`error`](#error)>>

#### <a id="method_connection_embed"></a>`[method]connection.embed: func`


##### Params

- <a id="method_connection_embed.self"></a>`self`: borrow<[`connection`](#connection)>
- <a id="method_connection_embed.table"></a>`table`: `string`
- <a id="method_connection_embed.data"></a>`data`: `string`

##### Return values

- <a id="method_connection_embed.0"></a> result<_, own<[`error`](#error)>>

#### <a id="method_connection_query"></a>`[method]connection.query: func`


##### Params

- <a id="method_connection_query.self"></a>`self`: borrow<[`connection`](#connection)>
- <a id="method_connection_query.table"></a>`table`: `string`
- <a id="method_connection_query.data"></a>`data`: `string`
- <a id="method_connection_query.options"></a>`options`: list<[`rag-option`](#rag_option)>

##### Return values

- <a id="method_connection_query.0"></a> result<list<`string`>, own<[`error`](#error)>>

#### <a id="connect"></a>`connect: func`


##### Params

- <a id="connect.dsn"></a>`dsn`: `string`

##### Return values

- <a id="connect.0"></a> result<own<[`connection`](#connection)>, own<[`error`](#error)>>

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

## <a id="wasi_http_types_0_2_0"></a>Import interface wasi:http/types@0.2.0

This interface defines all of the types and methods for implementing
HTTP Requests and Responses, both incoming and outgoing, as well as
their headers, trailers, and bodies.

----

### Types

#### <a id="duration"></a>`type duration`
[`duration`](#duration)
<p>
#### <a id="input_stream"></a>`type input-stream`
[`input-stream`](#input_stream)
<p>
#### <a id="output_stream"></a>`type output-stream`
[`output-stream`](#output_stream)
<p>
#### <a id="io_error"></a>`type io-error`
[`error`](#error)
<p>
#### <a id="pollable"></a>`type pollable`
[`pollable`](#pollable)
<p>
#### <a id="method"></a>`variant method`

This type corresponds to HTTP standard Methods.

##### Variant Cases

- <a id="method.get"></a>`get`
- <a id="method.head"></a>`head`
- <a id="method.post"></a>`post`
- <a id="method.put"></a>`put`
- <a id="method.delete"></a>`delete`
- <a id="method.connect"></a>`connect`
- <a id="method.options"></a>`options`
- <a id="method.trace"></a>`trace`
- <a id="method.patch"></a>`patch`
- <a id="method.other"></a>`other`: `string`
#### <a id="scheme"></a>`variant scheme`

This type corresponds to HTTP standard Related Schemes.

##### Variant Cases

- <a id="scheme.http"></a>`HTTP`
- <a id="scheme.https"></a>`HTTPS`
- <a id="scheme.other"></a>`other`: `string`
#### <a id="dns_error_payload"></a>`record DNS-error-payload`

Defines the case payload type for `DNS-error` above:

##### Record Fields

- <a id="dns_error_payload.rcode"></a>`rcode`: option<`string`>
- <a id="dns_error_payload.info_code"></a>`info-code`: option<`u16`>
#### <a id="tls_alert_received_payload"></a>`record TLS-alert-received-payload`

Defines the case payload type for `TLS-alert-received` above:

##### Record Fields

- <a id="tls_alert_received_payload.alert_id"></a>`alert-id`: option<`u8`>
- <a id="tls_alert_received_payload.alert_message"></a>`alert-message`: option<`string`>
#### <a id="field_size_payload"></a>`record field-size-payload`

Defines the case payload type for `HTTP-response-{header,trailer}-size` above:

##### Record Fields

- <a id="field_size_payload.field_name"></a>`field-name`: option<`string`>
- <a id="field_size_payload.field_size"></a>`field-size`: option<`u32`>
#### <a id="error_code"></a>`variant error-code`

These cases are inspired by the IANA HTTP Proxy Error Types:
https://www.iana.org/assignments/http-proxy-status/http-proxy-status.xhtml#table-http-proxy-error-types

##### Variant Cases

- <a id="error_code.dns_timeout"></a>`DNS-timeout`
- <a id="error_code.dns_error"></a>`DNS-error`: [`DNS-error-payload`](#dns_error_payload)
- <a id="error_code.destination_not_found"></a>`destination-not-found`
- <a id="error_code.destination_unavailable"></a>`destination-unavailable`
- <a id="error_code.destination_ip_prohibited"></a>`destination-IP-prohibited`
- <a id="error_code.destination_ip_unroutable"></a>`destination-IP-unroutable`
- <a id="error_code.connection_refused"></a>`connection-refused`
- <a id="error_code.connection_terminated"></a>`connection-terminated`
- <a id="error_code.connection_timeout"></a>`connection-timeout`
- <a id="error_code.connection_read_timeout"></a>`connection-read-timeout`
- <a id="error_code.connection_write_timeout"></a>`connection-write-timeout`
- <a id="error_code.connection_limit_reached"></a>`connection-limit-reached`
- <a id="error_code.tls_protocol_error"></a>`TLS-protocol-error`
- <a id="error_code.tls_certificate_error"></a>`TLS-certificate-error`
- <a id="error_code.tls_alert_received"></a>`TLS-alert-received`: [`TLS-alert-received-payload`](#tls_alert_received_payload)
- <a id="error_code.http_request_denied"></a>`HTTP-request-denied`
- <a id="error_code.http_request_length_required"></a>`HTTP-request-length-required`
- <a id="error_code.http_request_body_size"></a>`HTTP-request-body-size`: option<`u64`>
- <a id="error_code.http_request_method_invalid"></a>`HTTP-request-method-invalid`
- <a id="error_code.http_request_uri_invalid"></a>`HTTP-request-URI-invalid`
- <a id="error_code.http_request_uri_too_long"></a>`HTTP-request-URI-too-long`
- <a id="error_code.http_request_header_section_size"></a>`HTTP-request-header-section-size`: option<`u32`>
- <a id="error_code.http_request_header_size"></a>`HTTP-request-header-size`: option<[`field-size-payload`](#field_size_payload)>
- <a id="error_code.http_request_trailer_section_size"></a>`HTTP-request-trailer-section-size`: option<`u32`>
- <a id="error_code.http_request_trailer_size"></a>`HTTP-request-trailer-size`: [`field-size-payload`](#field_size_payload)
- <a id="error_code.http_response_incomplete"></a>`HTTP-response-incomplete`
- <a id="error_code.http_response_header_section_size"></a>`HTTP-response-header-section-size`: option<`u32`>
- <a id="error_code.http_response_header_size"></a>`HTTP-response-header-size`: [`field-size-payload`](#field_size_payload)
- <a id="error_code.http_response_body_size"></a>`HTTP-response-body-size`: option<`u64`>
- <a id="error_code.http_response_trailer_section_size"></a>`HTTP-response-trailer-section-size`: option<`u32`>
- <a id="error_code.http_response_trailer_size"></a>`HTTP-response-trailer-size`: [`field-size-payload`](#field_size_payload)
- <a id="error_code.http_response_transfer_coding"></a>`HTTP-response-transfer-coding`: option<`string`>
- <a id="error_code.http_response_content_coding"></a>`HTTP-response-content-coding`: option<`string`>
- <a id="error_code.http_response_timeout"></a>`HTTP-response-timeout`
- <a id="error_code.http_upgrade_failed"></a>`HTTP-upgrade-failed`
- <a id="error_code.http_protocol_error"></a>`HTTP-protocol-error`
- <a id="error_code.loop_detected"></a>`loop-detected`
- <a id="error_code.configuration_error"></a>`configuration-error`
- <a id="error_code.internal_error"></a>`internal-error`: option<`string`>
  <p>This is a catch-all error for anything that doesn't fit cleanly into a
  more specific case. It also includes an optional string for an
  unstructured description of the error. Users should not depend on the
  string for diagnosing errors, as it's not required to be consistent
  between implementations.

#### <a id="header_error"></a>`variant header-error`

This type enumerates the different kinds of errors that may occur when
setting or appending to a `fields` resource.

##### Variant Cases

- <a id="header_error.invalid_syntax"></a>`invalid-syntax`
  <p>This error indicates that a `field-key` or `field-value` was
  syntactically invalid when used with an operation that sets headers in a
  `fields`.

- <a id="header_error.forbidden"></a>`forbidden`
  <p>This error indicates that a forbidden `field-key` was used when trying
  to set a header in a `fields`.

- <a id="header_error.immutable"></a>`immutable`
  <p>This error indicates that the operation on the `fields` was not
  permitted because the fields are immutable.

#### <a id="field_key"></a>`type field-key`
`string`
<p>Field keys are always strings.

#### <a id="field_value"></a>`type field-value`
[`field-value`](#field_value)
<p>Field values should always be ASCII strings. However, in
reality, HTTP implementations often have to interpret malformed values,
so they are provided as a list of bytes.

#### <a id="fields"></a>`resource fields`

This following block defines the `fields` resource which corresponds to
HTTP standard Fields. Fields are a common representation used for both
Headers and Trailers.

A `fields` may be mutable or immutable. A `fields` created using the
constructor, `from-list`, or `clone` will be mutable, but a `fields`
resource given by other means (including, but not limited to,
`incoming-request.headers`, `outgoing-request.headers`) might be be
immutable. In an immutable fields, the `set`, `append`, and `delete`
operations will fail with `header-error.immutable`.
#### <a id="headers"></a>`type headers`
[`fields`](#fields)
<p>Headers is an alias for Fields.

#### <a id="trailers"></a>`type trailers`
[`fields`](#fields)
<p>Trailers is an alias for Fields.

#### <a id="incoming_request"></a>`resource incoming-request`

Represents an incoming HTTP Request.
#### <a id="outgoing_request"></a>`resource outgoing-request`

Represents an outgoing HTTP Request.
#### <a id="request_options"></a>`resource request-options`

Parameters for making an HTTP Request. Each of these parameters is
currently an optional timeout applicable to the transport layer of the
HTTP protocol.

These timeouts are separate from any the user may use to bound a
blocking call to `wasi:io/poll.poll`.
#### <a id="response_outparam"></a>`resource response-outparam`

Represents the ability to send an HTTP Response.

This resource is used by the `wasi:http/incoming-handler` interface to
allow a Response to be sent corresponding to the Request provided as the
other argument to `incoming-handler.handle`.
#### <a id="status_code"></a>`type status-code`
`u16`
<p>This type corresponds to the HTTP standard Status Code.

#### <a id="incoming_response"></a>`resource incoming-response`

Represents an incoming HTTP Response.
#### <a id="incoming_body"></a>`resource incoming-body`

Represents an incoming HTTP Request or Response's Body.

A body has both its contents - a stream of bytes - and a (possibly
empty) set of trailers, indicating that the full contents of the
body have been received. This resource represents the contents as
an `input-stream` and the delivery of trailers as a `future-trailers`,
and ensures that the user of this interface may only be consuming either
the body contents or waiting on trailers at any given time.
#### <a id="future_trailers"></a>`resource future-trailers`

Represents a future which may eventaully return trailers, or an error.

In the case that the incoming HTTP Request or Response did not have any
trailers, this future will resolve to the empty set of trailers once the
complete Request or Response body has been received.
#### <a id="outgoing_response"></a>`resource outgoing-response`

Represents an outgoing HTTP Response.
#### <a id="outgoing_body"></a>`resource outgoing-body`

Represents an outgoing HTTP Request or Response's Body.

A body has both its contents - a stream of bytes - and a (possibly
empty) set of trailers, inducating the full contents of the body
have been sent. This resource represents the contents as an
`output-stream` child resource, and the completion of the body (with
optional trailers) with a static function that consumes the
`outgoing-body` resource, and ensures that the user of this interface
may not write to the body contents after the body has been finished.

If the user code drops this resource, as opposed to calling the static
method `finish`, the implementation should treat the body as incomplete,
and that an error has occured. The implementation should propogate this
error to the HTTP protocol by whatever means it has available,
including: corrupting the body on the wire, aborting the associated
Request, or sending a late status code for the Response.
#### <a id="future_incoming_response"></a>`resource future-incoming-response`

Represents a future which may eventaully return an incoming HTTP
Response, or an error.

This resource is returned by the `wasi:http/outgoing-handler` interface to
provide the HTTP Response corresponding to the sent Request.
----

### Functions

#### <a id="http_error_code"></a>`http-error-code: func`

Attempts to extract a http-related `error` from the wasi:io `error`
provided.

Stream operations which return
`wasi:io/stream/stream-error::last-operation-failed` have a payload of
type `wasi:io/error/error` with more information about the operation
that failed. This payload can be passed through to this function to see
if there's http-related information about the error to return.

Note that this function is fallible because not all io-errors are
http-related errors.

##### Params

- <a id="http_error_code.err"></a>`err`: borrow<[`io-error`](#io_error)>

##### Return values

- <a id="http_error_code.0"></a> option<[`error-code`](#error_code)>

#### <a id="constructor_fields"></a>`[constructor]fields: func`

Construct an empty HTTP Fields.

The resulting `fields` is mutable.

##### Return values

- <a id="constructor_fields.0"></a> own<[`fields`](#fields)>

#### <a id="static_fields_from_list"></a>`[static]fields.from-list: func`

Construct an HTTP Fields.

The resulting `fields` is mutable.

The list represents each key-value pair in the Fields. Keys
which have multiple values are represented by multiple entries in this
list with the same key.

The tuple is a pair of the field key, represented as a string, and
Value, represented as a list of bytes. In a valid Fields, all keys
and values are valid UTF-8 strings. However, values are not always
well-formed, so they are represented as a raw list of bytes.

An error result will be returned if any header or value was
syntactically invalid, or if a header was forbidden.

##### Params

- <a id="static_fields_from_list.entries"></a>`entries`: list<([`field-key`](#field_key), [`field-value`](#field_value))>

##### Return values

- <a id="static_fields_from_list.0"></a> result<own<[`fields`](#fields)>, [`header-error`](#header_error)>

#### <a id="method_fields_get"></a>`[method]fields.get: func`

Get all of the values corresponding to a key. If the key is not present
in this `fields`, an empty list is returned. However, if the key is
present but empty, this is represented by a list with one or more
empty field-values present.

##### Params

- <a id="method_fields_get.self"></a>`self`: borrow<[`fields`](#fields)>
- <a id="method_fields_get.name"></a>`name`: [`field-key`](#field_key)

##### Return values

- <a id="method_fields_get.0"></a> list<[`field-value`](#field_value)>

#### <a id="method_fields_has"></a>`[method]fields.has: func`

Returns `true` when the key is present in this `fields`. If the key is
syntactically invalid, `false` is returned.

##### Params

- <a id="method_fields_has.self"></a>`self`: borrow<[`fields`](#fields)>
- <a id="method_fields_has.name"></a>`name`: [`field-key`](#field_key)

##### Return values

- <a id="method_fields_has.0"></a> `bool`

#### <a id="method_fields_set"></a>`[method]fields.set: func`

Set all of the values for a key. Clears any existing values for that
key, if they have been set.

Fails with `header-error.immutable` if the `fields` are immutable.

##### Params

- <a id="method_fields_set.self"></a>`self`: borrow<[`fields`](#fields)>
- <a id="method_fields_set.name"></a>`name`: [`field-key`](#field_key)
- <a id="method_fields_set.value"></a>`value`: list<[`field-value`](#field_value)>

##### Return values

- <a id="method_fields_set.0"></a> result<_, [`header-error`](#header_error)>

#### <a id="method_fields_delete"></a>`[method]fields.delete: func`

Delete all values for a key. Does nothing if no values for the key
exist.

Fails with `header-error.immutable` if the `fields` are immutable.

##### Params

- <a id="method_fields_delete.self"></a>`self`: borrow<[`fields`](#fields)>
- <a id="method_fields_delete.name"></a>`name`: [`field-key`](#field_key)

##### Return values

- <a id="method_fields_delete.0"></a> result<_, [`header-error`](#header_error)>

#### <a id="method_fields_append"></a>`[method]fields.append: func`

Append a value for a key. Does not change or delete any existing
values for that key.

Fails with `header-error.immutable` if the `fields` are immutable.

##### Params

- <a id="method_fields_append.self"></a>`self`: borrow<[`fields`](#fields)>
- <a id="method_fields_append.name"></a>`name`: [`field-key`](#field_key)
- <a id="method_fields_append.value"></a>`value`: [`field-value`](#field_value)

##### Return values

- <a id="method_fields_append.0"></a> result<_, [`header-error`](#header_error)>

#### <a id="method_fields_entries"></a>`[method]fields.entries: func`

Retrieve the full set of keys and values in the Fields. Like the
constructor, the list represents each key-value pair.

The outer list represents each key-value pair in the Fields. Keys
which have multiple values are represented by multiple entries in this
list with the same key.

##### Params

- <a id="method_fields_entries.self"></a>`self`: borrow<[`fields`](#fields)>

##### Return values

- <a id="method_fields_entries.0"></a> list<([`field-key`](#field_key), [`field-value`](#field_value))>

#### <a id="method_fields_clone"></a>`[method]fields.clone: func`

Make a deep copy of the Fields. Equivelant in behavior to calling the
`fields` constructor on the return value of `entries`. The resulting
`fields` is mutable.

##### Params

- <a id="method_fields_clone.self"></a>`self`: borrow<[`fields`](#fields)>

##### Return values

- <a id="method_fields_clone.0"></a> own<[`fields`](#fields)>

#### <a id="method_incoming_request_method"></a>`[method]incoming-request.method: func`

Returns the method of the incoming request.

##### Params

- <a id="method_incoming_request_method.self"></a>`self`: borrow<[`incoming-request`](#incoming_request)>

##### Return values

- <a id="method_incoming_request_method.0"></a> [`method`](#method)

#### <a id="method_incoming_request_path_with_query"></a>`[method]incoming-request.path-with-query: func`

Returns the path with query parameters from the request, as a string.

##### Params

- <a id="method_incoming_request_path_with_query.self"></a>`self`: borrow<[`incoming-request`](#incoming_request)>

##### Return values

- <a id="method_incoming_request_path_with_query.0"></a> option<`string`>

#### <a id="method_incoming_request_scheme"></a>`[method]incoming-request.scheme: func`

Returns the protocol scheme from the request.

##### Params

- <a id="method_incoming_request_scheme.self"></a>`self`: borrow<[`incoming-request`](#incoming_request)>

##### Return values

- <a id="method_incoming_request_scheme.0"></a> option<[`scheme`](#scheme)>

#### <a id="method_incoming_request_authority"></a>`[method]incoming-request.authority: func`

Returns the authority from the request, if it was present.

##### Params

- <a id="method_incoming_request_authority.self"></a>`self`: borrow<[`incoming-request`](#incoming_request)>

##### Return values

- <a id="method_incoming_request_authority.0"></a> option<`string`>

#### <a id="method_incoming_request_headers"></a>`[method]incoming-request.headers: func`

Get the `headers` associated with the request.

The returned `headers` resource is immutable: `set`, `append`, and
`delete` operations will fail with `header-error.immutable`.

The `headers` returned are a child resource: it must be dropped before
the parent `incoming-request` is dropped. Dropping this
`incoming-request` before all children are dropped will trap.

##### Params

- <a id="method_incoming_request_headers.self"></a>`self`: borrow<[`incoming-request`](#incoming_request)>

##### Return values

- <a id="method_incoming_request_headers.0"></a> own<[`headers`](#headers)>

#### <a id="method_incoming_request_consume"></a>`[method]incoming-request.consume: func`

Gives the `incoming-body` associated with this request. Will only
return success at most once, and subsequent calls will return error.

##### Params

- <a id="method_incoming_request_consume.self"></a>`self`: borrow<[`incoming-request`](#incoming_request)>

##### Return values

- <a id="method_incoming_request_consume.0"></a> result<own<[`incoming-body`](#incoming_body)>>

#### <a id="constructor_outgoing_request"></a>`[constructor]outgoing-request: func`

Construct a new `outgoing-request` with a default `method` of `GET`, and
`none` values for `path-with-query`, `scheme`, and `authority`.

* `headers` is the HTTP Headers for the Request.

It is possible to construct, or manipulate with the accessor functions
below, an `outgoing-request` with an invalid combination of `scheme`
and `authority`, or `headers` which are not permitted to be sent.
It is the obligation of the `outgoing-handler.handle` implementation
to reject invalid constructions of `outgoing-request`.

##### Params

- <a id="constructor_outgoing_request.headers"></a>`headers`: own<[`headers`](#headers)>

##### Return values

- <a id="constructor_outgoing_request.0"></a> own<[`outgoing-request`](#outgoing_request)>

#### <a id="method_outgoing_request_body"></a>`[method]outgoing-request.body: func`

Returns the resource corresponding to the outgoing Body for this
Request.

Returns success on the first call: the `outgoing-body` resource for
this `outgoing-request` can be retrieved at most once. Subsequent
calls will return error.

##### Params

- <a id="method_outgoing_request_body.self"></a>`self`: borrow<[`outgoing-request`](#outgoing_request)>

##### Return values

- <a id="method_outgoing_request_body.0"></a> result<own<[`outgoing-body`](#outgoing_body)>>

#### <a id="method_outgoing_request_method"></a>`[method]outgoing-request.method: func`

Get the Method for the Request.

##### Params

- <a id="method_outgoing_request_method.self"></a>`self`: borrow<[`outgoing-request`](#outgoing_request)>

##### Return values

- <a id="method_outgoing_request_method.0"></a> [`method`](#method)

#### <a id="method_outgoing_request_set_method"></a>`[method]outgoing-request.set-method: func`

Set the Method for the Request. Fails if the string present in a
`method.other` argument is not a syntactically valid method.

##### Params

- <a id="method_outgoing_request_set_method.self"></a>`self`: borrow<[`outgoing-request`](#outgoing_request)>
- <a id="method_outgoing_request_set_method.method"></a>`method`: [`method`](#method)

##### Return values

- <a id="method_outgoing_request_set_method.0"></a> result

#### <a id="method_outgoing_request_path_with_query"></a>`[method]outgoing-request.path-with-query: func`

Get the combination of the HTTP Path and Query for the Request.
When `none`, this represents an empty Path and empty Query.

##### Params

- <a id="method_outgoing_request_path_with_query.self"></a>`self`: borrow<[`outgoing-request`](#outgoing_request)>

##### Return values

- <a id="method_outgoing_request_path_with_query.0"></a> option<`string`>

#### <a id="method_outgoing_request_set_path_with_query"></a>`[method]outgoing-request.set-path-with-query: func`

Set the combination of the HTTP Path and Query for the Request.
When `none`, this represents an empty Path and empty Query. Fails is the
string given is not a syntactically valid path and query uri component.

##### Params

- <a id="method_outgoing_request_set_path_with_query.self"></a>`self`: borrow<[`outgoing-request`](#outgoing_request)>
- <a id="method_outgoing_request_set_path_with_query.path_with_query"></a>`path-with-query`: option<`string`>

##### Return values

- <a id="method_outgoing_request_set_path_with_query.0"></a> result

#### <a id="method_outgoing_request_scheme"></a>`[method]outgoing-request.scheme: func`

Get the HTTP Related Scheme for the Request. When `none`, the
implementation may choose an appropriate default scheme.

##### Params

- <a id="method_outgoing_request_scheme.self"></a>`self`: borrow<[`outgoing-request`](#outgoing_request)>

##### Return values

- <a id="method_outgoing_request_scheme.0"></a> option<[`scheme`](#scheme)>

#### <a id="method_outgoing_request_set_scheme"></a>`[method]outgoing-request.set-scheme: func`

Set the HTTP Related Scheme for the Request. When `none`, the
implementation may choose an appropriate default scheme. Fails if the
string given is not a syntactically valid uri scheme.

##### Params

- <a id="method_outgoing_request_set_scheme.self"></a>`self`: borrow<[`outgoing-request`](#outgoing_request)>
- <a id="method_outgoing_request_set_scheme.scheme"></a>`scheme`: option<[`scheme`](#scheme)>

##### Return values

- <a id="method_outgoing_request_set_scheme.0"></a> result

#### <a id="method_outgoing_request_authority"></a>`[method]outgoing-request.authority: func`

Get the HTTP Authority for the Request. A value of `none` may be used
with Related Schemes which do not require an Authority. The HTTP and
HTTPS schemes always require an authority.

##### Params

- <a id="method_outgoing_request_authority.self"></a>`self`: borrow<[`outgoing-request`](#outgoing_request)>

##### Return values

- <a id="method_outgoing_request_authority.0"></a> option<`string`>

#### <a id="method_outgoing_request_set_authority"></a>`[method]outgoing-request.set-authority: func`

Set the HTTP Authority for the Request. A value of `none` may be used
with Related Schemes which do not require an Authority. The HTTP and
HTTPS schemes always require an authority. Fails if the string given is
not a syntactically valid uri authority.

##### Params

- <a id="method_outgoing_request_set_authority.self"></a>`self`: borrow<[`outgoing-request`](#outgoing_request)>
- <a id="method_outgoing_request_set_authority.authority"></a>`authority`: option<`string`>

##### Return values

- <a id="method_outgoing_request_set_authority.0"></a> result

#### <a id="method_outgoing_request_headers"></a>`[method]outgoing-request.headers: func`

Get the headers associated with the Request.

The returned `headers` resource is immutable: `set`, `append`, and
`delete` operations will fail with `header-error.immutable`.

This headers resource is a child: it must be dropped before the parent
`outgoing-request` is dropped, or its ownership is transfered to
another component by e.g. `outgoing-handler.handle`.

##### Params

- <a id="method_outgoing_request_headers.self"></a>`self`: borrow<[`outgoing-request`](#outgoing_request)>

##### Return values

- <a id="method_outgoing_request_headers.0"></a> own<[`headers`](#headers)>

#### <a id="constructor_request_options"></a>`[constructor]request-options: func`

Construct a default `request-options` value.

##### Return values

- <a id="constructor_request_options.0"></a> own<[`request-options`](#request_options)>

#### <a id="method_request_options_connect_timeout"></a>`[method]request-options.connect-timeout: func`

The timeout for the initial connect to the HTTP Server.

##### Params

- <a id="method_request_options_connect_timeout.self"></a>`self`: borrow<[`request-options`](#request_options)>

##### Return values

- <a id="method_request_options_connect_timeout.0"></a> option<[`duration`](#duration)>

#### <a id="method_request_options_set_connect_timeout"></a>`[method]request-options.set-connect-timeout: func`

Set the timeout for the initial connect to the HTTP Server. An error
return value indicates that this timeout is not supported.

##### Params

- <a id="method_request_options_set_connect_timeout.self"></a>`self`: borrow<[`request-options`](#request_options)>
- <a id="method_request_options_set_connect_timeout.duration"></a>`duration`: option<[`duration`](#duration)>

##### Return values

- <a id="method_request_options_set_connect_timeout.0"></a> result

#### <a id="method_request_options_first_byte_timeout"></a>`[method]request-options.first-byte-timeout: func`

The timeout for receiving the first byte of the Response body.

##### Params

- <a id="method_request_options_first_byte_timeout.self"></a>`self`: borrow<[`request-options`](#request_options)>

##### Return values

- <a id="method_request_options_first_byte_timeout.0"></a> option<[`duration`](#duration)>

#### <a id="method_request_options_set_first_byte_timeout"></a>`[method]request-options.set-first-byte-timeout: func`

Set the timeout for receiving the first byte of the Response body. An
error return value indicates that this timeout is not supported.

##### Params

- <a id="method_request_options_set_first_byte_timeout.self"></a>`self`: borrow<[`request-options`](#request_options)>
- <a id="method_request_options_set_first_byte_timeout.duration"></a>`duration`: option<[`duration`](#duration)>

##### Return values

- <a id="method_request_options_set_first_byte_timeout.0"></a> result

#### <a id="method_request_options_between_bytes_timeout"></a>`[method]request-options.between-bytes-timeout: func`

The timeout for receiving subsequent chunks of bytes in the Response
body stream.

##### Params

- <a id="method_request_options_between_bytes_timeout.self"></a>`self`: borrow<[`request-options`](#request_options)>

##### Return values

- <a id="method_request_options_between_bytes_timeout.0"></a> option<[`duration`](#duration)>

#### <a id="method_request_options_set_between_bytes_timeout"></a>`[method]request-options.set-between-bytes-timeout: func`

Set the timeout for receiving subsequent chunks of bytes in the Response
body stream. An error return value indicates that this timeout is not
supported.

##### Params

- <a id="method_request_options_set_between_bytes_timeout.self"></a>`self`: borrow<[`request-options`](#request_options)>
- <a id="method_request_options_set_between_bytes_timeout.duration"></a>`duration`: option<[`duration`](#duration)>

##### Return values

- <a id="method_request_options_set_between_bytes_timeout.0"></a> result

#### <a id="static_response_outparam_set"></a>`[static]response-outparam.set: func`

Set the value of the `response-outparam` to either send a response,
or indicate an error.

This method consumes the `response-outparam` to ensure that it is
called at most once. If it is never called, the implementation
will respond with an error.

The user may provide an `error` to `response` to allow the
implementation determine how to respond with an HTTP error response.

##### Params

- <a id="static_response_outparam_set.param"></a>`param`: own<[`response-outparam`](#response_outparam)>
- <a id="static_response_outparam_set.response"></a>`response`: result<own<[`outgoing-response`](#outgoing_response)>, [`error-code`](#error_code)>

#### <a id="method_incoming_response_status"></a>`[method]incoming-response.status: func`

Returns the status code from the incoming response.

##### Params

- <a id="method_incoming_response_status.self"></a>`self`: borrow<[`incoming-response`](#incoming_response)>

##### Return values

- <a id="method_incoming_response_status.0"></a> [`status-code`](#status_code)

#### <a id="method_incoming_response_headers"></a>`[method]incoming-response.headers: func`

Returns the headers from the incoming response.

The returned `headers` resource is immutable: `set`, `append`, and
`delete` operations will fail with `header-error.immutable`.

This headers resource is a child: it must be dropped before the parent
`incoming-response` is dropped.

##### Params

- <a id="method_incoming_response_headers.self"></a>`self`: borrow<[`incoming-response`](#incoming_response)>

##### Return values

- <a id="method_incoming_response_headers.0"></a> own<[`headers`](#headers)>

#### <a id="method_incoming_response_consume"></a>`[method]incoming-response.consume: func`

Returns the incoming body. May be called at most once. Returns error
if called additional times.

##### Params

- <a id="method_incoming_response_consume.self"></a>`self`: borrow<[`incoming-response`](#incoming_response)>

##### Return values

- <a id="method_incoming_response_consume.0"></a> result<own<[`incoming-body`](#incoming_body)>>

#### <a id="method_incoming_body_stream"></a>`[method]incoming-body.stream: func`

Returns the contents of the body, as a stream of bytes.

Returns success on first call: the stream representing the contents
can be retrieved at most once. Subsequent calls will return error.

The returned `input-stream` resource is a child: it must be dropped
before the parent `incoming-body` is dropped, or consumed by
`incoming-body.finish`.

This invariant ensures that the implementation can determine whether
the user is consuming the contents of the body, waiting on the
`future-trailers` to be ready, or neither. This allows for network
backpressure is to be applied when the user is consuming the body,
and for that backpressure to not inhibit delivery of the trailers if
the user does not read the entire body.

##### Params

- <a id="method_incoming_body_stream.self"></a>`self`: borrow<[`incoming-body`](#incoming_body)>

##### Return values

- <a id="method_incoming_body_stream.0"></a> result<own<[`input-stream`](#input_stream)>>

#### <a id="static_incoming_body_finish"></a>`[static]incoming-body.finish: func`

Takes ownership of `incoming-body`, and returns a `future-trailers`.
This function will trap if the `input-stream` child is still alive.

##### Params

- <a id="static_incoming_body_finish.this"></a>`this`: own<[`incoming-body`](#incoming_body)>

##### Return values

- <a id="static_incoming_body_finish.0"></a> own<[`future-trailers`](#future_trailers)>

#### <a id="method_future_trailers_subscribe"></a>`[method]future-trailers.subscribe: func`

Returns a pollable which becomes ready when either the trailers have
been received, or an error has occured. When this pollable is ready,
the `get` method will return `some`.

##### Params

- <a id="method_future_trailers_subscribe.self"></a>`self`: borrow<[`future-trailers`](#future_trailers)>

##### Return values

- <a id="method_future_trailers_subscribe.0"></a> own<[`pollable`](#pollable)>

#### <a id="method_future_trailers_get"></a>`[method]future-trailers.get: func`

Returns the contents of the trailers, or an error which occured,
once the future is ready.

The outer `option` represents future readiness. Users can wait on this
`option` to become `some` using the `subscribe` method.

The outer `result` is used to retrieve the trailers or error at most
once. It will be success on the first call in which the outer option
is `some`, and error on subsequent calls.

The inner `result` represents that either the HTTP Request or Response
body, as well as any trailers, were received successfully, or that an
error occured receiving them. The optional `trailers` indicates whether
or not trailers were present in the body.

When some `trailers` are returned by this method, the `trailers`
resource is immutable, and a child. Use of the `set`, `append`, or
`delete` methods will return an error, and the resource must be
dropped before the parent `future-trailers` is dropped.

##### Params

- <a id="method_future_trailers_get.self"></a>`self`: borrow<[`future-trailers`](#future_trailers)>

##### Return values

- <a id="method_future_trailers_get.0"></a> option<result<result<option<own<[`trailers`](#trailers)>>, [`error-code`](#error_code)>>>

#### <a id="constructor_outgoing_response"></a>`[constructor]outgoing-response: func`

Construct an `outgoing-response`, with a default `status-code` of `200`.
If a different `status-code` is needed, it must be set via the
`set-status-code` method.

* `headers` is the HTTP Headers for the Response.

##### Params

- <a id="constructor_outgoing_response.headers"></a>`headers`: own<[`headers`](#headers)>

##### Return values

- <a id="constructor_outgoing_response.0"></a> own<[`outgoing-response`](#outgoing_response)>

#### <a id="method_outgoing_response_status_code"></a>`[method]outgoing-response.status-code: func`

Get the HTTP Status Code for the Response.

##### Params

- <a id="method_outgoing_response_status_code.self"></a>`self`: borrow<[`outgoing-response`](#outgoing_response)>

##### Return values

- <a id="method_outgoing_response_status_code.0"></a> [`status-code`](#status_code)

#### <a id="method_outgoing_response_set_status_code"></a>`[method]outgoing-response.set-status-code: func`

Set the HTTP Status Code for the Response. Fails if the status-code
given is not a valid http status code.

##### Params

- <a id="method_outgoing_response_set_status_code.self"></a>`self`: borrow<[`outgoing-response`](#outgoing_response)>
- <a id="method_outgoing_response_set_status_code.status_code"></a>`status-code`: [`status-code`](#status_code)

##### Return values

- <a id="method_outgoing_response_set_status_code.0"></a> result

#### <a id="method_outgoing_response_headers"></a>`[method]outgoing-response.headers: func`

Get the headers associated with the Request.

The returned `headers` resource is immutable: `set`, `append`, and
`delete` operations will fail with `header-error.immutable`.

This headers resource is a child: it must be dropped before the parent
`outgoing-request` is dropped, or its ownership is transfered to
another component by e.g. `outgoing-handler.handle`.

##### Params

- <a id="method_outgoing_response_headers.self"></a>`self`: borrow<[`outgoing-response`](#outgoing_response)>

##### Return values

- <a id="method_outgoing_response_headers.0"></a> own<[`headers`](#headers)>

#### <a id="method_outgoing_response_body"></a>`[method]outgoing-response.body: func`

Returns the resource corresponding to the outgoing Body for this Response.

Returns success on the first call: the `outgoing-body` resource for
this `outgoing-response` can be retrieved at most once. Subsequent
calls will return error.

##### Params

- <a id="method_outgoing_response_body.self"></a>`self`: borrow<[`outgoing-response`](#outgoing_response)>

##### Return values

- <a id="method_outgoing_response_body.0"></a> result<own<[`outgoing-body`](#outgoing_body)>>

#### <a id="method_outgoing_body_write"></a>`[method]outgoing-body.write: func`

Returns a stream for writing the body contents.

The returned `output-stream` is a child resource: it must be dropped
before the parent `outgoing-body` resource is dropped (or finished),
otherwise the `outgoing-body` drop or `finish` will trap.

Returns success on the first call: the `output-stream` resource for
this `outgoing-body` may be retrieved at most once. Subsequent calls
will return error.

##### Params

- <a id="method_outgoing_body_write.self"></a>`self`: borrow<[`outgoing-body`](#outgoing_body)>

##### Return values

- <a id="method_outgoing_body_write.0"></a> result<own<[`output-stream`](#output_stream)>>

#### <a id="static_outgoing_body_finish"></a>`[static]outgoing-body.finish: func`

Finalize an outgoing body, optionally providing trailers. This must be
called to signal that the response is complete. If the `outgoing-body`
is dropped without calling `outgoing-body.finalize`, the implementation
should treat the body as corrupted.

Fails if the body's `outgoing-request` or `outgoing-response` was
constructed with a Content-Length header, and the contents written
to the body (via `write`) does not match the value given in the
Content-Length.

##### Params

- <a id="static_outgoing_body_finish.this"></a>`this`: own<[`outgoing-body`](#outgoing_body)>
- <a id="static_outgoing_body_finish.trailers"></a>`trailers`: option<own<[`trailers`](#trailers)>>

##### Return values

- <a id="static_outgoing_body_finish.0"></a> result<_, [`error-code`](#error_code)>

#### <a id="method_future_incoming_response_subscribe"></a>`[method]future-incoming-response.subscribe: func`

Returns a pollable which becomes ready when either the Response has
been received, or an error has occured. When this pollable is ready,
the `get` method will return `some`.

##### Params

- <a id="method_future_incoming_response_subscribe.self"></a>`self`: borrow<[`future-incoming-response`](#future_incoming_response)>

##### Return values

- <a id="method_future_incoming_response_subscribe.0"></a> own<[`pollable`](#pollable)>

#### <a id="method_future_incoming_response_get"></a>`[method]future-incoming-response.get: func`

Returns the incoming HTTP Response, or an error, once one is ready.

The outer `option` represents future readiness. Users can wait on this
`option` to become `some` using the `subscribe` method.

The outer `result` is used to retrieve the response or error at most
once. It will be success on the first call in which the outer option
is `some`, and error on subsequent calls.

The inner `result` represents that either the incoming HTTP Response
status and headers have recieved successfully, or that an error
occured. Errors may also occur while consuming the response body,
but those will be reported by the `incoming-body` and its
`output-stream` child.

##### Params

- <a id="method_future_incoming_response_get.self"></a>`self`: borrow<[`future-incoming-response`](#future_incoming_response)>

##### Return values

- <a id="method_future_incoming_response_get.0"></a> option<result<result<own<[`incoming-response`](#incoming_response)>, [`error-code`](#error_code)>>>

## <a id="hayride_ai_runner_0_0_63"></a>Import interface hayride:ai/runner@0.0.63


----

### Types

#### <a id="message"></a>`type message`
[`message`](#message)
<p>
#### <a id="agent"></a>`type agent`
[`agent`](#agent)
<p>
#### <a id="format"></a>`type format`
[`format`](#format)
<p>
#### <a id="output_stream"></a>`type output-stream`
[`output-stream`](#output_stream)
<p>
#### <a id="tensor_stream"></a>`type tensor-stream`
[`tensor-stream`](#tensor_stream)
<p>
#### <a id="graph_execution_context_stream"></a>`type graph-execution-context-stream`
[`graph-execution-context-stream`](#graph_execution_context_stream)
<p>
#### <a id="graph_stream"></a>`type graph-stream`
[`graph-stream`](#graph_stream)
<p>
#### <a id="fields"></a>`type fields`
[`fields`](#fields)
<p>
#### <a id="response_outparam"></a>`type response-outparam`
[`response-outparam`](#response_outparam)
<p>
#### <a id="outgoing_response"></a>`type outgoing-response`
[`outgoing-response`](#outgoing_response)
<p>
#### <a id="outgoing_body"></a>`type outgoing-body`
[`outgoing-body`](#outgoing_body)
<p>
#### <a id="error_code"></a>`enum error-code`


##### Enum Cases

- <a id="error_code.invoke_error"></a>`invoke-error`
- <a id="error_code.unknown"></a>`unknown`
#### <a id="error"></a>`resource error`

#### <a id="runner"></a>`resource runner`

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

#### <a id="constructor_runner"></a>`[constructor]runner: func`


##### Params

- <a id="constructor_runner.sse_format"></a>`sse-format`: `bool`

##### Return values

- <a id="constructor_runner.0"></a> own<[`runner`](#runner)>

#### <a id="method_runner_invoke"></a>`[method]runner.invoke: func`


##### Params

- <a id="method_runner_invoke.self"></a>`self`: borrow<[`runner`](#runner)>
- <a id="method_runner_invoke.message"></a>`message`: [`message`](#message)
- <a id="method_runner_invoke.agent"></a>`agent`: borrow<[`agent`](#agent)>
- <a id="method_runner_invoke.format"></a>`format`: borrow<[`format`](#format)>
- <a id="method_runner_invoke.graph"></a>`graph`: borrow<[`graph-execution-context-stream`](#graph_execution_context_stream)>
- <a id="method_runner_invoke.output_stream"></a>`output-stream`: option<borrow<[`output-stream`](#output_stream)>>

##### Return values

- <a id="method_runner_invoke.0"></a> result<list<[`message`](#message)>, own<[`error`](#error)>>

