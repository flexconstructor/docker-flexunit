#!/usr/bin/env bats


@test "contains gradle" {
  run docker run --rm  $IMAGE gradle -version
  [ "$status" -eq 0 ]
}

@test "contains xvfb-run" {
  run docker run --rm  $IMAGE --help
  [ "$status" -eq 0 ]
}

@test "contains flash player" {
  run docker run --rm  $IMAGE stat /usr/bin/gflashplayer
  [ "$status" -eq 0 ]
}

@test "contains xvfb" {
  run docker run --rm  $IMAGE pidof /usr/bin/Xvfb
  [ "$status" -eq 0 ]
}
