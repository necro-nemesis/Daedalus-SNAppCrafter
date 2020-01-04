#!/usr/bin/env bash
screen -S snapp -d -m python3 -m http.server --bind localhost.loki 80 --directory /tmp/
