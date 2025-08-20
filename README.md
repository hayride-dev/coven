# Coven

Coven is a collection of WebAssembly Interface Types ( WIT ) that outline the supported host/guest Wasm imports and exports. It provides a structured way to define and interact with various Wasm-based components, enabling seamless communication between hosts and guests.

Hayride uses these interfaces in a few different locations: 
- [bindings](https://github.com/hayride-dev/bindings): This repository contains language-specific bindings for the WIT definitions. It can be viewed as the hayride "SDK". However, the sdk is not required to use, only the WIT defintions are enforced, meaning anyone can implement the WIT definitions in any language they choose.
- [morphs](https://github.com/hayride-dev/morphs): This repository implements various WebAssembly components, focusing largely on defining exported WIT interfaces. These components can be used as building blocks for creating more complex applications.

## Using the WIT Definitions
To use the WIT definitions in your project, you can include them as dependencies using tools like [wit-deps](https://github.com/bytecodealliance/wit-deps). This allows you to import the WIT files directly into your project and generate. 

Using wit-deps, you can add these definitions to your project by adding the following to your `deps.toml` file:

```toml
ai = "https://github.com/hayride-dev/coven/releases/download/v0.0.64/hayride_ai_v0.0.64.tar.gz"
```

Then reference them in your WIT files:

```wit
world example {
    export hayride:ai/agents@0.0.64;
}
```

We currently publish the WIT definitions to GitHub releases, which can be found in the [releases](https://github.com/hayride-dev/coven/releases) section of this repository. Each release contains a tarball with the WIT definitions, which will be used with `wit-deps`.

## Bindings Generation 

The primary goal of this repository is to store a collection of WIT defintions. The bindings are not stored or generated here. Using tools such as [wit-deps](https://github.com/bytecodealliance/wit-deps), you can include these definitions in your project and generate the bindings as needed.

To ensure syntax correctness and compatibility, we provide a way to generate test bindings for various languages.

You can see examples of generated bindings in our [bindings](https://github.com/hayride-dev/bindings) repository. 

### Markdown 
`make gen-md`

## Contributing
Contributions are welcome! If you'd like to contribute, please follow these steps:

- Fork the repository.
- Create a new branch for your feature or bug fix.
- Submit a pull request with a detailed description of your changes.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details