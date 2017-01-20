#!/usr/bin/env bats

@test "contains mxmlc compiler" {
  run docker run --rm  $IMAGE /flex-sdk/apache-flex-sdk-4.15.0-bin/bin/mxmlc \
  -help
  [ "$status" -eq 0 ]
}

@test "contains asdoc" {
  run docker run --rm  $IMAGE /flex-sdk/apache-flex-sdk-4.15.0-bin/bin/asdoc \
  -help
  [ "$status" -eq 0 ]
}

@test "contains fontswf" {
  run docker run --rm  $IMAGE stat /flex-sdk/apache-flex-sdk-4.15.0-bin/bin/fontswf
  [ "$status" -eq 0 ]
}

@test "contains playerglobal 23.0 swc" {
  run docker run --rm  $IMAGE stat \
  /flex-sdk/apache-flex-sdk-4.15.0-bin/frameworks/libs/player/23.0/playerglobal.swc
  [ "$status" -eq 0 ]
}

@test "contains playerglobal 11.1 swc" {
  run docker run --rm  $IMAGE stat \
  /flex-sdk/apache-flex-sdk-4.15.0-bin/frameworks/libs/player/11.1/playerglobal.swc
  [ "$status" -eq 0 ]
}

@test "contains flex fontkit" {
  run docker run --rm  $IMAGE stat \
  /flex-sdk/apache-flex-sdk-4.15.0-bin/lib/external/optional/flex-fontkit.jar
  [ "$status" -eq 0 ]
}