{ pkgs, ... }:

{
  packages = [
    pkgs.cargo-binstall
    pkgs.cargo-insta
    pkgs.cargo-make
    pkgs.cargo-nextest
    pkgs.cargo-run-bin
    pkgs.curl
    pkgs.dprint
    pkgs.fnm
    pkgs.jq
    pkgs.kubectl
    pkgs.rustup
  ];

  env.POSTGRES_DB = "kj";
  env.POSTGRES_PASSWORD = "kj";
  env.POSTGRES_USER = "kj";
  env.POSTGRES_PORT = 5433;
  env.KUBECONFIG = "setup/.kube/config";

  services.postgres = {
    enable = true;
    package = pkgs.postgresql_15;
    initialDatabases = [{ name = "kj"; }];
    port = 5433;
    initialScript = "CREATE USER 'kj' SUPERUSER WITH PASSWORD 'kj';";
  };

  # Scripts
  scripts."install:all".exec = ''
    set -e
    install:pnpm
    install:cargo:bin
    install:solana
    install:pulumi
    install:esc
    prisma generate
  '';
  scripts."install:pnpm".exec = ''
    pnpm install
    pnpm playwright install
  '';
  scripts."install:cargo:bin".exec = ''
    cargo bin --install
  '';
  scripts."update:deps".exec = ''
    cargo update
    pnpm update --latest --recursive -i
  '';
  scripts."anchor".exec = ''
    cargo bin anchor $@
  '';
  scripts."pulumi-resource-pulumi-nodejs".exec = ''
    node_modules/@pulumi/pulumi/pulumi-resource-pulumi-nodejs $@
  '';
  scripts."leptos".exec = ''
    cargo bin leptos $@
  '';
  scripts."prettier".exec = ''
    ./node_modules/.bin/prettier $@
  '';
  scripts."prisma".exec = ''
    cargo prisma $@
  '';
  scripts."watch:kickjump_com".exec = ''
    cargo make watch:kickjump_com
  '';
  scripts."build:kickjump_com".exec = ''
    set -e
    pnpm tailwindcss -i ./apps/kickjump_com/style/input.css -o ./apps/kickjump_com/style/output.css --config ./apps/kickjump_com/tailwind.config.ts
    cargo leptos build --project kickjump_com --release -vv
  '';
  scripts."serve:kickjump_com".exec = ''
    set -e
    cargo leptos serve --release --project kickjump_com
  '';
  scripts."prepare:kickjump_com".exec = ''
    set -e
    rm -rf dist/kickjump_com
    mkdir -p dist/kickjump_com
    cp target/release/kickjump_com dist/kickjump_com/run
    cp -r target/site/kickjump_com dist/kickjump_com/site
    cp -r apps/kickjump_com/Cargo.toml dist/kickjump_com
  '';
  scripts."fix:all".exec = ''
    set -e
    fix:clippy
    fix:format
    fix:es
  '';
  scripts."fix:format".exec = ''
    set -e
    dprint fmt
  '';
  scripts."fix:clippy".exec = ''
    set -e
    cargo clippy --fix --allow-dirty --allow-staged
  '';
  scripts."fix:es".exec = ''
    set -e
    pnpm eslint --ext=.tsx,.ts,.js . --fix
  '';
  scripts."lint:all".exec = ''
    set -e
    lint:format
    lint:clippy
    lint:es
  '';
  scripts."lint:format".exec = ''
    set -e
    dprint check
  '';
  scripts."lint:clippy".exec = ''
    set -e
    cargo clippy
  '';
  scripts."lint:es".exec = ''
    set -e
    pnpm eslint --ext=.tsx,.ts,.js .
  '';
  scripts."snapshot:review".exec = ''
    cargo insta review
  '';
  scripts."snapshot:update".exec = ''
    cargo nextest run
    cargo insta accept
  '';
  scripts."test:all".exec = ''
    set -e
    test:cargo
    test:docs
  '';
  scripts."test:cargo".exec = ''
    set -e
    cargo nextest run
  '';
  scripts."test:kickjump_com".exec = ''
    set -e
    pnpm playwright test -c apps/kickjump_com/e2e/playwright.config.ts
  '';
  scripts."test:docs".exec = ''
    set -e
    cargo test --doc
  '';
  scripts."setup:vscode".exec = ''
    set -e
    rm -rf .vscode
    cp -r ./setup/editors/vscode .vscode
  '';
  scripts."setup:ci".exec = ''
    set -e
    # update github ci path
    echo "$DEVENV_PROFILE/bin" >> $GITHUB_PATH
    echo "$GITHUB_WORKSPACE/.local-cache/solana-release/bin" >> $GITHUB_PATH
    echo "$GITHUB_WORKSPACE/.local-cache/pulumi" >> $GITHUB_PATH
    echo "$GITHUB_WORKSPACE/.local-cache/esc" >> $GITHUB_PATH

    # update github ci environment
    echo "DEVENV_PROFILE=$DEVENV_PROFILE" >> $GITHUB_ENV

    # prepend common compilation lookup paths
    echo PKG_CONFIG_PATH=$PKG_CONFIG_PATH" >> $GITHUB_ENV
    echo LD_LIBRARY_PATH=$LD_LIBRARY_PATH" >> $GITHUB_ENV
    echo LIBRARY_PATH=$LIBRARY_PATH" >> $GITHUB_ENV
    echo C_INCLUDE_PATH=$C_INCLUDE_PATH" >> $GITHUB_ENV

    # these provide shell completions / default config options
    echo XDG_DATA_DIRS=$XDG_DATA_DIRS" >> $GITHUB_ENV
    echo XDG_CONFIG_DIRS=$XDG_CONFIG_DIRS" >> $GITHUB_ENV

    echo DEVENV_DOTFILE=$DEVENV_DOTFILE" >> $GITHUB_ENV
    echo DEVENV_PROFILE=$DEVENV_PROFILE" >> $GITHUB_ENV
    echo DEVENV_ROOT=$DEVENV_ROOT" >> $GITHUB_ENV
    echo DEVENV_STATE=$DEVENV_STATE" >> $GITHUB_ENV

    fnm_env=$(fnm env --json)

    # Parse the JSON file contents
    PARSED_FNM_ENV=$(jq -r '.' <<< "$fnm_env")
    FNM_MULTISHELL_PATH=$(jq -r '.FNM_MULTISHELL_PATH' <<< "$PARSED_FNM_ENV")

    # Add fnm to the path
    echo "$FNM_MULTISHELL_PATH/bin" >> $GITHUB_PATH

    # add fnm environment variables
    for key in $(jq -r 'keys[]' <<< "$PARSED_FNM_ENV"); do
      value=$(jq -r ".$key" <<< "$PARSED_FNM_ENV")
      echo "$key=$value" >> $GITHUB_ENV
    done
  '';
  scripts."install:solana".exec = ''
    SOLANA_DOWNLOAD_ROOT="https://github.com/solana-labs/solana/releases/download"
    LOCAL_CACHE=.local-cache
    VERSION=`cat ./setup/cache-versions.json | jq -r '.solana'`
    OS_TYPE="$(uname -s)"
    CPU_TYPE="$(uname -m)"

    case "$OS_TYPE" in
      Linux)
        OS_TYPE=unknown-linux-gnu
        ;;
      Darwin)
        if [[ $CPU_TYPE = arm64 ]]; then
          CPU_TYPE=aarch64
        fi
        OS_TYPE=apple-darwin
        ;;
      *)
        err "machine architecture is currently unsupported"
        ;;
    esac
    TARGET="$CPU_TYPE-$OS_TYPE"

    mkdir -p $LOCAL_CACHE
    TAR_PATH=solana-release-$TARGET.tar.bz2
    FULL_TAR_PATH="$LOCAL_CACHE/$TAR_PATH"
    if [[ -e $FULL_TAR_PATH ]]
    then
      echo "Using cached solana release"
    else
      DOWNLOAD_URL="$SOLANA_DOWNLOAD_ROOT/$VERSION/$TAR_PATH"
      echo "Downloading $DOWNLOAD_URL to the local cache $FULL_TAR_PATH"
      curl --header "Authorization: Bearer $GITHUB_TOKEN" -sSfL "$DOWNLOAD_URL" -O
      mv $TAR_PATH $FULL_TAR_PATH
      tar jxf $FULL_TAR_PATH -C $LOCAL_CACHE
    fi
  '';
  scripts."install:pulumi".exec = ''
    LOCAL_CACHE=.local-cache
    VERSION=`cat ./setup/cache-versions.json | jq -r '.pulumi'`
    OS_TYPE=""
    case $(uname) in
        "Linux") OS_TYPE="linux";;
        "Darwin") OS_TYPE="darwin";;
        *)
            print_unsupported_platform
            exit 1
            ;;
    esac

    CPU_TYPE=""
    case $(uname -m) in
        "x86_64") CPU_TYPE="x64";;
        "arm64") CPU_TYPE="arm64";;
        "aarch64") CPU_TYPE="arm64";;
        *)
            print_unsupported_platform
            exit 1
            ;;
    esac

    TARBALL_URL="https://github.com/pulumi/pulumi/releases/download/$VERSION"
    TARBALL_URL_FALLBACK="https://get.pulumi.com/releases/sdk/"
    TARBALL_PATH=pulumi-$VERSION-$OS_TYPE-$CPU_TYPE.tar.gz
    mkdir -p $LOCAL_CACHE
    FULL_TARBALL_PATH="$LOCAL_CACHE/$TARBALL_PATH"

    if [[ -e $FULL_TARBALL_PATH ]]
    then
      echo "Using cached pulumi release"
    else
      DOWNLOAD_URL="$TARBALL_URL/$TARBALL_PATH"
      echo "Downloading $DOWNLOAD_URL to the local cache $FULL_TARBALL_PATH"
      curl --header "Authorization: Bearer $GITHUB_TOKEN" -sSfL "$DOWNLOAD_URL" -O
      mv $TARBALL_PATH $FULL_TARBALL_PATH
      tar zxf $FULL_TARBALL_PATH -C $LOCAL_CACHE
    fi

  '';
  scripts."install:esc".exec = ''
    LOCAL_CACHE=.local-cache
    VERSION=`cat ./setup/cache-versions.json | jq -r '.esc'`
    OS_TYPE=""
    case $(uname) in
        "Linux") OS_TYPE="linux";;
        "Darwin") OS_TYPE="darwin";;
        *)
            print_unsupported_platform
            exit 1
            ;;
    esac

    CPU_TYPE=""
    case $(uname -m) in
        "x86_64") CPU_TYPE="x64";;
        "arm64") CPU_TYPE="arm64";;
        "aarch64") CPU_TYPE="arm64";;
        *)
            print_unsupported_platform
            exit 1
            ;;
    esac

    TARBALL_URL="https://github.com/pulumi/esc/releases/download/$VERSION"
    TARBALL_URL_FALLBACK="https://get.pulumi.com/esc/releases/"
    TARBALL_PATH=esc-$VERSION-$OS_TYPE-$CPU_TYPE.tar.gz
    mkdir -p $LOCAL_CACHE
    FULL_TARBALL_PATH="$LOCAL_CACHE/$TARBALL_PATH"

    if [[ -e $FULL_TARBALL_PATH ]]
    then
      echo "Using cached esc release"
    else
      DOWNLOAD_URL="$TARBALL_URL/$TARBALL_PATH"
      echo "Downloading $DOWNLOAD_URL to the local cache $FULL_TARBALL_PATH"
      curl --header "Authorization: Bearer $GITHUB_TOKEN" -sSfL "$DOWNLOAD_URL" -O
      mv $TARBALL_PATH $FULL_TARBALL_PATH
      tar zxf $FULL_TARBALL_PATH -C $LOCAL_CACHE
    fi
  '';
}
