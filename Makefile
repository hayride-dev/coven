.PHONY: clean gen-md

default: gen-md

# Set default value for world if not provided
world ?= runtime

deps: ; wit-deps update

gen-md: ; wit-bindgen markdown --world $(world) --out-dir . ./wit 

test-gen-rust: ; wit-bindgen rust --generate-all --world $(world) --out-dir ./gen/rust ./wit 

test-gen-c: ; wit-bindgen c --world $(world) --out-dir ./gen/c ./wit 

clean: ; rm -rf ./gen/*   

help: ; echo "make gen-md world\n" && echo "available worlds: runtime,ai,wasip2,http-client"
