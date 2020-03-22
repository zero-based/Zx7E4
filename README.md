# Zx7E4

Zx7E4 is a processor simulated using [VHDL](https://en.wikipedia.org/wiki/VHDL).  
The name is the combination of [`zero-based`](https://zero-based.github.io/) and `0x7E4` _(2020 in HEX)_.

## Stack

- [GHDL][ghdl]: an open-source simulator for the VHDL language.
- [VUint][vuint]: an open source unit testing framework for VHDL.
- [GTKWave][gtkwave]: a fully featured GTK+ based wave viewer.

[ghdl]: http://ghdl.free.fr/
[vuint]: https://vunit.github.io/
[gtkwave]: http://gtkwave.sourceforge.net/

## Start

1. Install [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop).
1. Install [VcXsrv Windows X Server](https://sourceforge.net/projects/vcxsrv/).
1. Run both **Docker Desktop** and **VcXsrv** _(with default config)_.

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

## Guidelines

- Use [VHDL Formatter](https://marketplace.visualstudio.com/items?itemName=Vinrobot.vhdl-formatter) for code formatting.
- Use short descriptive names.
- Use Generics and Constants wherever possible.
- Configure tab size to **2 spaces**.
