# docker-flexunit
Gradle container based on Ubuntu
This container include:
* Ant
* Gradle
* Xvfb
* Flash Player 11.1 Projector content debugger
* FlexSDK 4.15
* FlexUnit 4.2.0

## Usage
By defaut, running this image will run 
For example, you can run the following to build and test flash/flex application:

```
docker run --rm -v /path/to/your/project:/opt/flash/workspace:rw flexconstructor/docker-flexunit

```

Simple usage example with Gradle [here](https://github.com/flexconstructor/docker-flex-unit-example)

## Get the Image
To build this image yourself, run...

```
docker build github.com/flexconstructor/docker-flexunit

```

You can pull the image from the central docker repository by using...

```
docker pull flexconstructor/docker-flexunit

```
