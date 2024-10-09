# <a id="ai"></a>World ai


 - Imports:
    - interface `wasi:nn/tensor@0.2.0-rc-2024-08-19`
    - interface `wasi:nn/errors@0.2.0-rc-2024-08-19`
    - interface `wasi:nn/inference@0.2.0-rc-2024-08-19`
    - interface `wasi:nn/graph@0.2.0-rc-2024-08-19`

## <a id="wasi_nn_tensor_0_2_0_rc_2024_08_19"></a>Import interface wasi:nn/tensor@0.2.0-rc-2024-08-19

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

## <a id="wasi_nn_errors_0_2_0_rc_2024_08_19"></a>Import interface wasi:nn/errors@0.2.0-rc-2024-08-19

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

## <a id="wasi_nn_inference_0_2_0_rc_2024_08_19"></a>Import interface wasi:nn/inference@0.2.0-rc-2024-08-19

An inference "session" is encapsulated by a `graph-execution-context`. This structure binds a
`graph` to input tensors before `compute`-ing an inference:

----

### Types

#### <a id="error"></a>`type error`
[`error`](#error)
<p>
#### <a id="tensor"></a>`type tensor`
[`tensor`](#tensor)
<p>
#### <a id="tensor_data"></a>`type tensor-data`
[`tensor-data`](#tensor_data)
<p>
#### <a id="graph_execution_context"></a>`resource graph-execution-context`

Bind a `graph` to the input and output tensors for an inference.

TODO: this may no longer be necessary in WIT
(https://github.com/WebAssembly/wasi-nn/issues/43)
----

### Functions

#### <a id="method_graph_execution_context_set_input"></a>`[method]graph-execution-context.set-input: func`

Define the inputs to use for inference.

##### Params

- <a id="method_graph_execution_context_set_input.self"></a>`self`: borrow<[`graph-execution-context`](#graph_execution_context)>
- <a id="method_graph_execution_context_set_input.name"></a>`name`: `string`
- <a id="method_graph_execution_context_set_input.tensor"></a>`tensor`: own<[`tensor`](#tensor)>

##### Return values

- <a id="method_graph_execution_context_set_input.0"></a> result<_, own<[`error`](#error)>>

#### <a id="method_graph_execution_context_compute"></a>`[method]graph-execution-context.compute: func`

Compute the inference on the given inputs.

Note the expected sequence of calls: `set-input`, `compute`, `get-output`. TODO: this
expectation could be removed as a part of
https://github.com/WebAssembly/wasi-nn/issues/43.

##### Params

- <a id="method_graph_execution_context_compute.self"></a>`self`: borrow<[`graph-execution-context`](#graph_execution_context)>

##### Return values

- <a id="method_graph_execution_context_compute.0"></a> result<_, own<[`error`](#error)>>

#### <a id="method_graph_execution_context_get_output"></a>`[method]graph-execution-context.get-output: func`

Extract the outputs after inference.

##### Params

- <a id="method_graph_execution_context_get_output.self"></a>`self`: borrow<[`graph-execution-context`](#graph_execution_context)>
- <a id="method_graph_execution_context_get_output.name"></a>`name`: `string`

##### Return values

- <a id="method_graph_execution_context_get_output.0"></a> result<own<[`tensor`](#tensor)>, own<[`error`](#error)>>

## <a id="wasi_nn_graph_0_2_0_rc_2024_08_19"></a>Import interface wasi:nn/graph@0.2.0-rc-2024-08-19

A `graph` is a loaded instance of a specific ML model (e.g., MobileNet) for a specific ML
framework (e.g., TensorFlow):

----

### Types

#### <a id="error"></a>`type error`
[`error`](#error)
<p>
#### <a id="tensor"></a>`type tensor`
[`tensor`](#tensor)
<p>
#### <a id="graph_execution_context"></a>`type graph-execution-context`
[`graph-execution-context`](#graph_execution_context)
<p>
#### <a id="graph"></a>`resource graph`

An execution graph for performing inference (i.e., a model).
#### <a id="graph_encoding"></a>`enum graph-encoding`

Describes the encoding of the graph. This allows the API to be implemented by various
backends that encode (i.e., serialize) their graph IR with different formats.

##### Enum Cases

- <a id="graph_encoding.openvino"></a>`openvino`
- <a id="graph_encoding.onnx"></a>`onnx`
- <a id="graph_encoding.tensorflow"></a>`tensorflow`
- <a id="graph_encoding.pytorch"></a>`pytorch`
- <a id="graph_encoding.tensorflowlite"></a>`tensorflowlite`
- <a id="graph_encoding.ggml"></a>`ggml`
- <a id="graph_encoding.autodetect"></a>`autodetect`
#### <a id="execution_target"></a>`enum execution-target`

Define where the graph should be executed.

##### Enum Cases

- <a id="execution_target.cpu"></a>`cpu`
- <a id="execution_target.gpu"></a>`gpu`
- <a id="execution_target.tpu"></a>`tpu`
#### <a id="graph_builder"></a>`type graph-builder`
[`graph-builder`](#graph_builder)
<p>The graph initialization data.

This gets bundled up into an array of buffers because implementing backends may encode their
graph IR in parts (e.g., OpenVINO stores its IR and weights separately).

----

### Functions

#### <a id="method_graph_init_execution_context"></a>`[method]graph.init-execution-context: func`


##### Params

- <a id="method_graph_init_execution_context.self"></a>`self`: borrow<[`graph`](#graph)>

##### Return values

- <a id="method_graph_init_execution_context.0"></a> result<own<[`graph-execution-context`](#graph_execution_context)>, own<[`error`](#error)>>

#### <a id="load"></a>`load: func`

Load a `graph` from an opaque sequence of bytes to use for inference.

##### Params

- <a id="load.builder"></a>`builder`: list<[`graph-builder`](#graph_builder)>
- <a id="load.encoding"></a>`encoding`: [`graph-encoding`](#graph_encoding)
- <a id="load.target"></a>`target`: [`execution-target`](#execution_target)

##### Return values

- <a id="load.0"></a> result<own<[`graph`](#graph)>, own<[`error`](#error)>>

#### <a id="load_by_name"></a>`load-by-name: func`

Load a `graph` by name.

How the host expects the names to be passed and how it stores the graphs for retrieval via
this function is **implementation-specific**. This allows hosts to choose name schemes that
range from simple to complex (e.g., URLs?) and caching mechanisms of various kinds.

##### Params

- <a id="load_by_name.name"></a>`name`: `string`

##### Return values

- <a id="load_by_name.0"></a> result<own<[`graph`](#graph)>, own<[`error`](#error)>>

