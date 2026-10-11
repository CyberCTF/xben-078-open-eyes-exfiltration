#!/bin/sh
# Places the player's flag (CTF_FLAG_MAIN, given by the launcher) in the ctf volume; without one
# (CI, a run by hand) the development flag. The machine's ctf-entrypoint.sh reads it on a restart.
dev='FLAG{dev-xben-078-open-eyes-exfiltration}'
printf '%s\n' "${CTF_FLAG_MAIN:-$dev}" > /ctf/flag
chmod 444 /ctf/flag
