# Proto

Protocol buffer definitions and generated code for Infracost services.

## Prerequisites

Install [buf](https://buf.build):

```bash
# via brew
brew install bufbuild/buf/buf

# via go
go install github.com/bufbuild/buf/cmd/buf@latest
```

## Development

After modifying `.proto` files, generate the code:

```bash
make generate
```

Commit both the `.proto` changes and the generated code in `gen/`.

## IDE Setup

If your IDE shows broken imports for proto files:

**VSCode**: Install the `vscode-proto3` extension and add to `.vscode/settings.json`:
```json
{
  "protoc": {
    "options": [
      "--proto_path=${workspaceRoot}/proto"
    ]
  }
}
```

**IntelliJ/GoLand**: Right-click `proto/` → Mark Directory as → Protobuf Include Path
