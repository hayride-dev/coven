.PHONY: clean gen-go

default: gen-go

# Set default value for world if not provided
world ?= llm

deps: ; wit-deps update

gen-go: ; wit-bindgen-go generate --world $(world) --out ./gen/go/ ./wit

clean: ; rm -rf ./gen/go/* & rm -rf ./gen/go/*