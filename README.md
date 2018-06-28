# MaxineVM in docker
Resources for building, running and hacking on MaxineVM in a docker container
## Running maxineVM
### Build the image

Enter the directory with the Dockerfile and run:

```
docker build ./ -t maxine
```

### Getting Maxine VM and Graal

Create a new directory:

```
mkdir maxine-src
```

and clone the source code of Maxine VM and Graal in it

```
git clone https://github.com/beehive-lab/Maxine-VM.git maxine-src/maxine
git clone https://github.com/beehive-lab/Maxine-Graal.git maxine-src/graal
```

### Starting the docker image

From the directory containing the directory created
in [Getting Maxine VM and Graal](#getting-maxine-vm-and-graal)

```
docker run -v $(pwd)/maxine-src:/maxine-src -ti --rm maxine bash
```

This will start the docker image and open a shell prompt where you can
execute the mx commands etc...

* `-v $(pwd)/maxine-src:/maxine-src` essentially mounts the host
  `$(pwd)/maxine-src` directory to the docker container `/maxine-src`
  directory.  Any changes performed outside the docker container are
  visible to the container and vice versa.
* `-ti` instructs docker to create an interactive session with a
  pseudo-tty, to allow us to interact with the container.
* `--rm` instructs docker to delete the container after we close it.
  Don't use this if you want to keep bash history among sessions.

## Hacking on maxineVM (using the inspector)
[Build the image](#build-the-image) and [get Maxine VM and Graal](#getting-maxine-vm-and-graal)

### Starting the docker image

Add the docker host name to the list allowed to make connections to the X server
```
xhost local:developer
```

From the directory containing the directory created
in [Getting Maxine VM and Graal](#getting-maxine-vm-and-graal)

```
docker run -v $(pwd)/maxine-src:/maxine-src \
					 -v /tmp/.X11-unix:/tmp/.X11-unix \
					 -e DISPLAY=unix$DISPLAY \
					 --cap-add=SYS_PTRACE \
					 -ti \
					 --rm \
					 maxine bash
```

This will start the docker image and open a shell prompt where you can 
execute the mx commands that start the inspector...

* `-v /tmp/.X11-unix:/tmp/.X11-unix` mounts the host X11 socket to the 
  container socket. 
* `-e DISPLAY=unix$DISPLAY` passes in the DISPLAY environment variable.
* `--cap-add=SYS_PTRACE` enables ptrace capability for the container.
