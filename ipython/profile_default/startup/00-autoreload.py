"""
IPython startup config (applies to ptipython too).

- Enable autoreload (mode 2)
- Friendlier tracebacks
- Pretty printing
- Common imports (optional)
"""

from IPython import get_ipython
from pathlib import Path

ip = get_ipython()
if ip is not None:
    ip.run_line_magic("load_ext", "autoreload")
    ip.run_line_magic("autoreload", "2")
    ip.run_line_magic("xmode", "Context")

    try:
        import polars as pl
    except Exception:
        pass

