#!/usr/bin/env bash

set -o errexit
set -o pipefail

LATEX_FLAGS="-interaction=nonstopmode -synctex=1 -shell-escape -file-line-error"

 Proper handling of SIGTERM from e.g. `docker stop` command
 Reference: https://unix.stackexchange.com/a/444676
prep_term()
{
  unset latexmk_pid
  unset kill_needed
  trap 'handle_term' TERM INT
}

handle_term()
{
  if [ "${latexmk_pid}" ]; then
    kill -TERM "${latexmk_pid}" 2>/dev/null
  else
    kill_needed="yes"
  fi
}

wait_term()
{
  latexmk_pid=$!
  if [ "${kill_needed}" ]; then
    kill -TERM "${latexmk_pid}" 2>/dev/null
  fi
  wait ${latexmk_pid} 2>/dev/null
  trap - TERM INT
  wait ${latexmk_pid} 2>/dev/null
}

prep_term
exec latexmk \
  -silent -pdf -pvc -view=none \
  -r "conf/glossaries.latexmk" \
  -pdflatex="pdflatex ${LATEX_FLAGS}" \
  thesis &
wait_term
