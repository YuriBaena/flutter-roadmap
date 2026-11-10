#!/bin/sh
set -u

while :; do
    # Usar -H ou garantir que o find escaneie a pasta corretamente
    find src/main -name "*.java" -o -name "*.xml" | entr -n -d -r mvn -B spring-boot:run
    status=$?
    if [ "$status" -ne 0 ]; then
        exit "$status"
    fi
done