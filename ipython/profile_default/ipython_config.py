"""
IPython configuration for interactive shells (including ptipython).
"""

c = get_config()  # noqa: F821 (provided by IPython at runtime)

# Vim keybindings in IPython itself (separate from ptpython's vi-mode).
c.TerminalInteractiveShell.editing_mode = "vi"

# More context in tracebacks.
c.InteractiveShell.xmode = "Context"

# Pretty printing.
c.TerminalInteractiveShell.pprint = True

