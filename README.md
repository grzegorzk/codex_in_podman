# Codex in Podman

Run **OpenAI Codex** (`codex`) within unprivileged Podman (or Docker) container 

Installed directly from https://chatgpt.com/codex/install.sh

## Why?

 - Extra layer to ensure agent can access / modify / (or damage) what is explicitly exposed

## Requirements

- [Podman](https://podman.io/) or [Docker](https://www.docker.com/) (installed and configured)
- GNU Make

### macOS (Apple Silicon) setup

The base image is amd64-only. Enable Rosetta **before** creating the podman machine — add to `~/.config/containers/containers.conf`:

```
[machine]
rosetta = true
```

Then create the VM (rootless is the default and is what this setup expects):

```bash
podman machine init
podman machine start
```

If podman was upgraded via brew after the machine was created, recreate it — a client/server version mismatch (check `podman version`) silently breaks TTY allocation and Claude Code exits with "Input must be provided either through stdin or as a prompt argument when using --print":

```bash
podman machine rm && podman machine init && podman machine start
```

## Getting Started

Note: all `make` commands below make use of Podman by default. Pass `Docker=docker` if you prefer to run in docker container.

### Build the image

```bash
make build
```

### Add below function at the end of your .bashrc, replace `/path/to/codex_in_podman` with full path where codex_in_podman was cloned to

```bash
function codex {
    codex_dir=/path/to/codex_in_podman
    if [ -z "$1" ]; then
        echo "Call 'codex .' or 'codex /path/to/project'";
    else
        proj_dir=$(cd "$1" && pwd);
        make -s -C $codex_dir run HOST_PATH_TO_PROJECT="$proj_dir" CONTAINER_PATH_TO_MOUNT_PROJECT="$proj_dir";
    fi;
}
```

Once updated:

```bash
source ~/.bashrc
```

You can then call codex as you would normally do:

```bash
cd path/to/your/project
codex .
```

### You can also run the container manually

```bash
make run HOST_PATH_TO_PROJECT=/path/to/your/project
```

## Configuration

- **`DOCKER`**: Defaults to `podman`.
- **`ARCH_BASE_IMAGE`**: Defaults to `techgk/arch:latest`.

# Thanks

ArchLinux:
* https://archlinux.org/

Podman:
* https://podman.io/

OpenAI:
* https://github.com/openai/codex
