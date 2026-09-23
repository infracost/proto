# Releasing

The version in `package.json` is the single source of truth for both the
npm package and the Go module. Go reads module versions from git tags, and
a workflow creates the tag from `package.json`, so nobody pushes tags by
hand.

## Release a new version

1. In the PR that changes `proto/`, bump the version:

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

## Checks on the PR

The `Version check` workflow fails a PR when:

- files under `proto/` changed but the version is not higher than on `main`
- `package-lock.json` has a different version than `package.json`

## Tag missing after a merge

If the tag was not created, run the workflow by hand from `main`:

```bash
gh workflow run tag-release.yml --ref main
```

It only creates a tag that does not exist yet, so running it again is safe.
Existing tags are never moved.
