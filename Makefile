.PHONY: clean gen-go

default: gen-go

# Set default value for world if not provided
world ?= llm

deps: ; wit-deps update

gen-go: ; wit-bindgen-go generate --world $(world) --out ./gen/go/ ./wit

gen-rust: ; wit-bindgen rust --generate-all --world $(world) --out-dir ./gen/rust ./wit 

gen-c: ; wit-bindgen c --world $(world) --out-dir ./gen/c ./wit 

clean: ; rm -rf ./gen/go/* & rm -rf ./gen/rust/*  
