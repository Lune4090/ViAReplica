#!/bin/sh

echo "lanching julia on current dir environment..."

julia --threads=4 --sysimage="SysIm.so"
