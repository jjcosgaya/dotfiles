#!/bin/sh
# tuigreet wrapper: monochrome Kanagawa Dragon on the Linux VT.
#
# The Linux virtual console can only render the 16 ANSI colors, so
# tuigreet --theme hex values are ignored. Instead we reprogram the VT
# palette itself (see console_codes(4): ESC ] P nrrggbb), then reference
# the colors by ANSI name. Only the black/gray/white entries are used by
# the theme below; the accent colors stay in the palette for everything
# else the VT might draw.

# Palette index is ONE hex digit (0-9, a-f), followed by rrggbb.
printf '\033]P0181616'    # 0 black          -> dragonBlack3 (background)
printf '\033]P1c4746e'    # 1 red            -> dragonRed
printf '\033]P287a987'    # 2 green          -> dragonGreen
printf '\033]P3c4b28a'    # 3 yellow         -> dragonYellow
printf '\033]P48ba4b0'    # 4 blue           -> dragonBlue2
printf '\033]P5a292a3'    # 5 magenta        -> dragonPink
printf '\033]P68ea4a2'    # 6 cyan           -> dragonAqua
printf '\033]P7a6a69c'    # 7 gray           -> dragonGray   (dim foreground)
printf '\033]P8625e5a'    # 8 darkgray       -> dragonBlack6 (subtle)
printf '\033]P9c4746e'    # 9 light red      -> dragonRed
printf '\033]Pa87a987'    # a light green    -> dragonGreen
printf '\033]Pbc4b28a'    # b light yellow   -> dragonYellow
printf '\033]Pc8ba4b0'    # c light blue     -> dragonBlue2
printf '\033]Pda292a3'    # d light magenta  -> dragonPink
printf '\033]Pe8ea4a2'    # e light cyan     -> dragonAqua
printf '\033]Pfc5c9c5'    # f white          -> dragonWhite  (bright foreground)

# Repaint the screen so the new background color takes effect everywhere.
clear

# Dimensions:
#   --width N              box width in columns
#   --window-padding N     blank lines above/below the box
#   --container-padding N  blank lines between the border and the prompt rows
#   --prompt-padding N     blank lines between the prompt rows themselves
# There is no height option; the box height comes from content + paddings.
exec tuigreet \
  --time --time-format '%a %d %b · %H:%M' \
  --remember \
  --asterisks --asterisks-char '●' \
  --width 56 --window-padding 2 --container-padding 2 --prompt-padding 1 \
  --theme 'container=black;border=darkgray;text=white;title=gray;greet=darkgray;prompt=gray;input=white;action=darkgray;button=darkgray;time=darkgray' \
  --cmd /usr/bin/niri-session
