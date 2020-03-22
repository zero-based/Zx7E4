from pathlib import Path
from vunit import VUnit

root = Path(__file__).parent
project = VUnit.from_argv()

project.add_library("Zx7E4").add_source_files([
    root / "src" / "*.vhd",
    root / "src" / "types" / "*.vhd",
    root / "test" / "*.vhd"
])

project.main()