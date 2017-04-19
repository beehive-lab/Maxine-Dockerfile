# Running maxineVM in docker

## Build the image

Enter the directory with the Dockerfile and run:

```
docker build ./ -t maxine
```

## Getting Maxine VM and Graal

Create a new directory:

```
mkdir maxine-src
```

and clone the source code of Maxine VM and Graal in it

```
hg clone https://kenai.com/hg/maxine~maxine maxine-src/maxine
hg clone https://kenai.com/hg/maxine~graal maxine-src/graal
```

## Starting the docker image

From the directory containing the directory created
in [Getting Maxine VM and Graal](#getting-maxine-vm-and-graal)

```
docker run -v $(pwd)/maxine-src:/maxine-src -u $(id -u):$(id -g) -ti --rm maxine bash
```

This will start the docker image and open a shell prompt where you can
execute the mx commands etc...

* `-u $(id -u):$(id -g)` instructs docker to write and read files as the
  current user instead of root which is the default.
* `-v $(pwd)/maxine-kenai:/maxine-kenai` essentially mounts the host
  `$(pwd)/maxine-kenai` directory to the docker container `/maxine-kenai`
  directory.  Any changes performed outside the docker container are
  visible to the container and vice versa.
* `--ti` instructs docker to create an interactive session with a
  pseudo-tty, to allow us to interact with the container.
* `--rm` instructs docker to delete the container after we close it.
  Don't use this if you want to keep bash history among sessions.
