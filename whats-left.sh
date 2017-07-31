#!/usr/bin/env bash
# This requires OPAM2 to work.
# Run it with `docker run -it ocaml/opam-dev:alpine` for a suitable environment

# List all the opam packages depending on camlp4.
# Note that this will list older packages if they have since
# been ported away from ppx.
USES_CAMLP4=`opam list -s --depends-on camlp4 --columns name`

echo "| Package | Ported | Camlp4 version | Latest version | Notes |"
echo "| ------- | ------ | -------------- | -------------- | ----- |"
for i in ${USES_CAMLP4}; do
  # get the latest version of this package
  LATEST_VERSION=`opam info $i -f version`
  # get the camlp4 version of this package
  CAMLP4_VERSION=`opam list -s --depends-on camlp4 --columns name,version | grep "^$i "|awk -F' ' '{print $2}'`
  if [ "${LATEST_VERSION}" = "${CAMLP4_VERSION}" ]; then
    MARKER="[ ]"
  else
    MARKER="[x]"
  fi
  # skip packages prefixed with pa_ since they are meant to be camlp4 only
  if [[ $i == pa_* ]]; then
    true
  else
    echo "| $i | ${MARKER} | ${CAMLP4_VERSION} | ${LATEST_VERSION} | |"
  fi
done
