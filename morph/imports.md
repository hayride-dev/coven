# <a id="imports"></a>World imports


 - Imports:
    - interface `hayride:morph/types@0.0.2`

## <a id="hayride_morph_types_0_0_2"></a>Import interface hayride:morph/types@0.0.2


----

### Types

#### <a id="spawn_error"></a>`variant spawn-error`


##### Variant Cases

- <a id="spawn_error.invalid_syntax"></a>`invalid-syntax`
- <a id="spawn_error.forbidden"></a>`forbidden`
- <a id="spawn_error.internal_error"></a>`internal-error`
#### <a id="spawn"></a>`resource spawn`

----

### Functions

#### <a id="constructor_spawn"></a>`[constructor]spawn: func`


##### Return values

- <a id="constructor_spawn.0"></a> own<[`spawn`](#spawn)>

#### <a id="method_spawn_exec"></a>`[method]spawn.exec: func`


##### Params

- <a id="method_spawn_exec.self"></a>`self`: borrow<[`spawn`](#spawn)>
- <a id="method_spawn_exec.name"></a>`name`: `string`
- <a id="method_spawn_exec.args"></a>`args`: list<`u8`>

##### Return values

- <a id="method_spawn_exec.0"></a> result<list<`u8`>, [`spawn-error`](#spawn_error)>

