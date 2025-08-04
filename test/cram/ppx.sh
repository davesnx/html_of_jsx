#!/bin/sh

set -eu

usage() {
  echo "Usage: $(basename "$0") --output re [--flags=\"...\"] [file.re]"
  echo "       $(basename "$0") --output ml [--flags=\"...\"] [file.re]"
}

FLAGS=""
FILE=""

# Check if 3rd argument is flags or file
if [ $# -ge 3 ]; then
  if [ "${3#--flags=}" != "$3" ]; then
    # 3rd argument is flags
    FLAGS="${3#--flags=}"
    if [ $# -ge 4 ]; then
      FILE="$4"
    else
      echo "Error: Missing input file after flags"
      usage
      exit 1
    fi
  else
    # 3rd argument is file
    FILE="$3"
  fi
else
  echo "Error: Missing input file"
  usage
  exit 1
fi

refmt --parse re --print ml "$FILE" > output.ml

# Pass flags to jsx-ppx-standalone if provided
if [ -n "$FLAGS" ]; then
  jsx-ppx-standalone --impl output.ml -o temp.ml "$FLAGS"
else
  jsx-ppx-standalone --impl output.ml -o temp.ml
fi

if [ "$2" = "ml" ]; then
  ocamlformat --enable-outside-detected-project --impl temp.ml -o temp.ml
  cat temp.ml
  exit
elif [ "$2" = "re" ]; then
  refmt --parse ml --print re temp.ml
  exit
else
  usage
  exit
fi
