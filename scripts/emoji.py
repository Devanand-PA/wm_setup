#!/usr/bin/env python3
"""
Emoji/kanji picker.

Reads every *.txt file in ~/.scripts/emoji/, feeds the lines into a
menu program (dmenu / rofi / fzf), takes the first whitespace-separated
field of whatever was picked, and either copies it to the clipboard or
prints it to stdout.

Equivalent of the original shell script, with two bugs fixed:
  - `[ -z $1 ]`      -> broke with no argument (unquoted empty expansion)
  - `[ $1=="-p" ]`   -> was always true, regardless of the argument

Usage:
    emoji_picker.py            # copy selection to clipboard
    emoji_picker.py -p         # print selection instead of copying
    emoji_picker.py --menu fzf # use fzf instead of dmenu
"""

import argparse
import glob
import os
import subprocess
import sys

EMOJI_DIR = os.path.expanduser("~/.scripts/emoji")


def iter_lines(directory):
    """
    Yield lines from every .txt file in `directory`, one at a time.

    This keeps Python's own memory usage low and lets you start writing
    into the menu process before every file has finished being read,
    which matters once files get into the megabyte range. It does NOT
    make dmenu itself lazy -- dmenu reads all of stdin before it draws
    anything, so very large files can still make dmenu slow or make it
    fail to open at all. See --menu fzf below for that case.
    """
    for path in sorted(glob.glob(os.path.join(directory, "*.txt"))):
        try:
            with open(path, "r", encoding="utf-8", errors="replace") as f:
                for line in f:
                    line = line.rstrip("\n")
                    if line.strip():
                        yield line
        except OSError as e:
            print(f"warning: couldn't read {path}: {e}", file=sys.stderr)


def run_menu(lines, menu_cmd):
    """Stream lines into the menu program's stdin and return its stdout."""
    proc = subprocess.Popen(
        menu_cmd,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        text=True,
        bufsize=1,
    )
    try:
        for line in lines:
            proc.stdin.write(line + "\n")
    except BrokenPipeError:
        # user picked something before all lines were sent -- fine
        pass
    finally:
        try:
            proc.stdin.close()
        except BrokenPipeError:
            pass

    out, _ = proc.communicate()
    return out.strip()


def first_field(s):
    parts = s.split()
    return parts[0] if parts else ""


def copy_to_clipboard(text):
    subprocess.run(["xclip", "-selection", "clipboard"], input=text, text=True)


def build_menu_cmd(args):
    if args.menu == "dmenu":
        return ["dmenu", "-l", str(args.lines), "-i"]
    if args.menu == "rofi":
        return ["rofi", "-dmenu", "-i", "-l", str(args.lines)]
    if args.menu == "fzf":
        return ["fzf"]
    raise ValueError(args.menu)


def main():
    parser = argparse.ArgumentParser(description="Pick an emoji/kanji from a menu")
    parser.add_argument(
        "-p", "--print", action="store_true",
        help="print the selection to stdout instead of copying to clipboard",
    )
    parser.add_argument(
        "--menu", default="dmenu", choices=["dmenu", "rofi", "fzf"],
        help="menu backend to use (default: dmenu). fzf handles very large "
             "lists far better than dmenu, but runs in a terminal.",
    )
    parser.add_argument(
        "-l", "--lines", type=int, default=30,
        help="number of lines to show, for dmenu/rofi (default: 30)",
    )
    args = parser.parse_args()

    menu_cmd = build_menu_cmd(args)

    try:
        selection = run_menu(iter_lines(EMOJI_DIR), menu_cmd)
    except FileNotFoundError:
        print(f"error: '{menu_cmd[0]}' not found in PATH", file=sys.stderr)
        sys.exit(1)

    if not selection:
        return

    result = first_field(selection)

    if args.print:
        print(result)
    else:
        copy_to_clipboard(result)


if __name__ == "__main__":
    main()
