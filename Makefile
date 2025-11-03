SHELL := /bin/bash

default: generate

.PHONY: lint
lint:
	buf lint

.PHONY: clean
clean:
	rm -rf gen/

.PHONY: format
format:
	buf format -w

.PHONY: generate
generate: clean lint format _generate verify

.PHONY: _generate
_generate:
	buf generate

.PHONY: verify
verify: verify-go verify-ts

.PHONY: verify-go
verify-go:
	go build ./gen/go/...

.PHONY: verify-ts
verify-ts:
	find gen/ts -name '*.ts' -exec npx -y tsc --noEmit --skipLibCheck {} +
