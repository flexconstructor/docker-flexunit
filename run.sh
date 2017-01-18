#!/bin/bash
cd /opt/flash/workspace
xvfb-run -e /dev/stdout --server-args="$DISPLAY -screen 0 700x500x24 -ac +extension RANDR" gradle build