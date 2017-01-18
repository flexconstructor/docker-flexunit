# docker-flexunit
Gradle container based on Debian.
This container include:
* Gradle
* Xvfb
* Flash Player 24.0 Projector content debugger

## Usage
See docker-compose.yml file

For run:

```
$ docker-compose up --build
```

## Get the Image
To build this image yourself, run...

```
docker build github.com/flexconstructor/docker-flexunit

```

You can pull the image from the central docker repository by using...

```
docker pull flexconstructor/docker-flexunit

```

## Changes:
1. FlexSDK isolated as a separate image.
2. Removed FlexUnit.
3. Add example project.
4. Used Flash player v.24 CA content debugger.
