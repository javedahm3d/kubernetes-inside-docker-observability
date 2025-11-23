#!/bin/bash

# Detect if running in Git Bash on Windows
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    DOCKER_RUN="winpty docker"
else
    DOCKER_RUN="docker"
fi

case "${1:-all}" in
    build)
        docker build --no-cache -t wiki-cluster .
        ;;
    run)
        $DOCKER_RUN run --privileged --cgroupns=host -p 8080:8080 -it wiki-cluster
        ;;
    all)
        docker build --no-cache -t wiki-cluster .
        $DOCKER_RUN run --privileged --cgroupns=host -p 8080:8080 -it wiki-cluster
        ;;
    clean)
        docker ps -q --filter ancestor=wiki-cluster | xargs -r docker stop
        docker ps -aq --filter ancestor=wiki-cluster | xargs -r docker rm
        ;;
    rebuild)
        docker ps -q --filter ancestor=wiki-cluster | xargs -r docker stop
        docker ps -aq --filter ancestor=wiki-cluster | xargs -r docker rm
        docker build -t wiki-cluster .
        $DOCKER_RUN run --privileged --cgroupns=host -p 8080:8080 -it wiki-cluster
        ;;
    *)
        echo "Usage: ./run.sh [build|run|all|clean|rebuild]"
        echo "  build   - Build the Docker image"
        echo "  run     - Run the container"
        echo "  all     - Build and run (default)"
        echo "  clean   - Stop and remove containers"
        echo "  rebuild - Clean, build, and run"
        exit 1
        ;;
esac