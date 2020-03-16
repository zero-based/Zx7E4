# Zx7E4

## Windows Environment

1. Install [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop).
1. Install [VcXsrv Windows X Server](https://sourceforge.net/projects/vcxsrv/).
1. Run both **Docker Desktop** and **VcXsrv** _(with default config)_ before running any command.

## Start

### Run Container

```bash
docker-compose run --rm main python run.py
```

> VS Code Task: `run-container` (<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>B</kbd>)

### Run Container (Graphical Mode)

```bash
docker-compose run --rm main python run.py -g
```

> VS Code Task: `run-container-graphical`
