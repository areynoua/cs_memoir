#!/bin/bash

echo $(sed -n 's/^\s*\\input{\(parts\/[^}]\+\)\(\.tex\)\?}/\1.tex/gp' main.tex) .vimrc main.tex
