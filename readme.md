<p align="center">
  <a href="#">
    <img width="300" height="300" src="./setup/assets/logo.svg"  />
  </a>
</p>

<p align="center">
  Your toolkit for financially sustainable open source development.
</p>

<br />

<p align="center">
  <a href="#getting-started"><strong>Getting Started</strong></a> ·
  <a href="#why"><strong>Why?</strong></a> ·
  <a href="#plans"><strong>Plans</strong></a> ·
  <a href="./docs/docs"><strong>Documentation</strong></a> ·
  <a href="./.github/contributing.md"><strong>Contributing</strong></a>
</p>

<br />

<p align="center">
  <a href="https://github.com/kickjump/kickjump/actions?query=workflow:ci">
    <img src="https://github.com/kickjump/kickjump/workflows/ci/badge.svg?branch=main" alt="Continuous integration badge for github actions" title="CI Badge" />
  </a>
</p>

<br />

## Description

Open source software has taken over the world.

Everything we work on, whether as employees, artistic souls, musically inclined or a side project junkies, we are reliant on open source software at some layer.

The value created by open source developers is astounding.

The problem is that almost none of the value created is passed onto the teams behind these open source projects. This is true even of ecosystem critical projects. Creators find themselves pleading for enough to sustain their work.

**KickJump** solves this fundamental problem by providing a toolkit for open source developers to build financially sustainable projects.

- Stakeholders can financially speculate on via project tokens.
- Governance is incentivized and monetized via tokens and credentials.
- Project specific rules based on the needs and requirements.
- Provide a suite of tools to enhance value creation of project stakeholders via zero-effort revenue share arrangements.

## Contributing

[`devenv`](https://devenv.sh/) is used to provide a reproducible development environment for this project. Follow the [getting started instructions](https://devenv.sh/getting-started/).

To automatically load the environment you should [install direnv](https://devenv.sh/automatic-shell-activation/) and then load the `direnv`.

```bash
# The security mechanism didn't allow to load the `.envrc`.
# Since we trust it, let's allow it execution.
direnv allow .
```

At this point you should see the `nix` commands available in your terminal.

Run the following commands to install all the required dependencies.

```bash
install:all
```

This installs all the node dependencies, cargo binaries and solana tooling locally so you don't need to worry about polluting your global namespace.

### Upgrading `devenv`

If you have an outdated version of `devenv` you can update it by running the following commands. If you have an easier way, please create a PR and I'll update these docs.

```bash
nix profile list # find the index of the nxi package
nix profile remove <index>
nix profile install --accept-flake-config github:cachix/devenv/<version>
```

### Editor Setup

To setup recommended configuration for your favourite editor run the following commands.

```bash
setup:vscode # Setup vscode
```

```
## License

BSD 3-Clause, see the [LICENSE](./LICENSE) file.
```
