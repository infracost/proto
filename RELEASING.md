# Releasing

The version in `package.json` is the single source of truth for both the
npm package and the Go module. Go reads module versions from git tags, and
a workflow creates the tag from `package.json`, so nobody pushes tags by
hand.

## Release a new version

1. In any PR that changes `proto/` or `gen/`, bump the version:

   ```bash
   npm version minor   # or patch / major
   ```

   The repo `.npmrc` stops npm from creating a commit or tag, so this only
   updates `package.json` and `package-lock.json`. Commit both.

2. Merge the PR. The `Tag release from package.json` workflow creates the
   `v<version>` tag on `main`.

3. Use the new version:

   ```bash
   go get github.com/infracost/proto@v1.171.0
   ```

## Which part to bump

- **patch**: fixes that don't change the API, such as comments or docs.
- **minor**: new messages, fields, enum values, or services.
- **major**: breaking changes. `buf breaking` blocks these on PRs, so a
  major bump should be rare and agreed with the team first.

  For Go, a major bump is more than a version number. Go ignores a `v2.0.0`
  tag unless the module path ends in `/v2`, so the release also needs the
  module path in `go.mod` changed to `github.com/infracost/proto/v2`, the
  `go_package_prefix` in `buf.gen.yaml` updated to match, and the code in
  `gen/go` regenerated.

## Checks on the PR

The `Version check` workflow fails a PR when:

- files under `proto/` or `gen/` changed but the version is not higher
  than on `main`
- `package-lock.json` has a different version than `package.json`

## Tag missing after a merge

If the tag was not created, run the workflow by hand from `main`:

```bash
gh workflow run tag-release.yml --ref main
```

It only creates a tag that does not exist yet, so running it again is safe.
Existing tags are never moved.

## Tag workflow fails with "already exists"

Two PRs picked the same version, and the second one merged after the first
was tagged. Its changes are on `main` but not in any tag. Open a new PR
that bumps the version again; merging it tags everything.
