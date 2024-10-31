#!/usr/bin/env bash

set -e


SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

phpVersions=(
    7.1
)

for phpVersion in ${phpVersions[@]}; do
    # Build Nginx + PHP-FPM flavors
    docker build \
      --build-arg PHP_VERSION="${phpVersion}" \
      -t "zero41software/fly-laravel:${phpVersion}" \
      -f "${SCRIPT_DIR}/src/Dockerfile" \
      "${SCRIPT_DIR}/src"

    # Build Nginx Unit flavors
    docker build \
      --build-arg PHP_VERSION="${phpVersion}" \
      -t "zero41software/fly-laravel:unit-${phpVersion}" \
      -f "${SCRIPT_DIR}/src/Dockerfile-unit" \
      "${SCRIPT_DIR}/src"
done

if [[ $# -gt 0 ]] && [[ $1 == "push" ]]; then
    for phpVersion in ${phpVersions[@]}; do
        docker push "zero41software/fly-laravel:${phpVersion}"
        docker push "zero41software/fly-laravel:unit-${phpVersion}"
    done
fi
