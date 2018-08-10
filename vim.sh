#!/bin/bash

vim $(sed -n 's/^\s*\\input{\(parts\/[^}]\+\)\(\.tex\)\?}/\1.tex/gp' main.tex) main.tex .vimrc
