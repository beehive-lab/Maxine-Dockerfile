# Running maxineVM in docker

## Build the image

Enter the directory with the Dockerfile and run:

```
docker build ./ -t maxine-dev
```

## Getting Maxine VM

Create a new directory:

```
mkdir maxine-src
```

and clone the source code of mx and Maxine VM in it

```
git clone https://github.com/graalvm/mx.git mx
git clone https://github.com/beehive-lab/Maxine-VM.git maxine
```

## Starting the docker image

From the directory `maxine-src` (created in [Getting Maxine VM](#getting-maxine-vm))

```
docker run --mount src="$(pwd)",target="/maxine-src",type=bind --mount src="$HOME/.mx",target="/home/user/.mx",type=bind -e UID=$(id -u) -e GID=$(id -g) -ti maxine-dev bash
```

This will start the docker image and open a shell prompt where you can execute the mx commands etc...

- `-u $(id -u):$(id -g)` instructs docker to write and read files as the current user instead of root which is the default.
- `--mount src="$(pwd)/maxine-src",target="/maxine-src",type=bind` essentially mounts the host `$(pwd)/maxine-kenai` directory to the docker container `/maxine-src` directory.
  Similarly, `--mount src="$HOME/.mx",target="/home/user/.mx",type=bind` does the same for the `~.mx` directory.
  Any changes performed outside the docker container are visible to the container and vice versa.
- `-ti` instructs docker to create an interactive session with a pseudo-tty, to allow us to interact with the container.
- `--rm` instructs docker to delete the container after we close it.
  Don't use this if you want to keep bash history among sessions.
