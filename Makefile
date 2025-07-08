.PHONY: clean gen-md deps package

default: gen-md

deps: ; wit-deps update

gen-md: 
	wit-bindgen markdown --world syntax --out-dir ./wit/ ./wit

release:
	@for dir in */ ; do \
        dir=$${dir%/}; \
        wit_file=$$(find $$dir/wit -maxdepth 1 -name '*.wit' | head -n 1); \
        if [ -n "$$wit_file" ]; then \
            echo "Processing directory: $$dir"; \
            package_info=$$(grep -Eo 'package[[:space:]]+[a-zA-Z0-9:_@.]+' $$wit_file | awk '{print $$2}'); \
            if [ -n "$$package_info" ]; then \
                package_name=$$(echo $$package_info | sed 's/:/_/g' | sed 's/@/_v/'); \
                echo "Package name: $$package_name"; \
                tar -czf "$$package_name.tar.gz" -C "$$dir" .; \
            else \
                echo "No package name found in $$wit_file"; \
            fi \
        else \
            echo "No .wit files found in $$dir/wit"; \
        fi \
    done

clean: ; rm -rf **/gen & rm -rf *.tar.gz