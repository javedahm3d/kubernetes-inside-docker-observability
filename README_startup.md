# Wiki Cluster

## Running the Container

### 1. Direct Docker Commands

```bash
# Build - Creates the Docker image from Dockerfile
docker build --no-cache -t wiki-cluster .

# Run - Starts the container with required privileges
docker run --privileged --cgroupns=host -p 8080:8080 -it wiki-cluster
```

### 2. Windows

```cmd
.\run.bat all      # Build the image and run the container
.\run.bat build    # Build the Docker image only
.\run.bat run      # Run the container (image must exist)
.\run.bat clean    # Stop and remove all wiki-cluster containers
```

### 3. Linux / macOS

```bash
# First time only - Make script executable
chmod +x run.sh

# Usage
./run.sh all       # Build the image and run the container
./run.sh build     # Build the Docker image only
./run.sh run       # Run the container (image must exist)
./run.sh clean     # Stop and remove all wiki-cluster containers
```

## Access

```
http://localhost:8080
```

## Why Not Docker Compose?

Docker Compose was not used because the `cgroupns: host` property is not supported in the Docker Compose and the container won't start without this flag.