# Inspired (and in some cases, like the helper functions, straight copied) from
# [jessfraz/dotfiles][1] (see license at end of file), this is a bunch of
# wrappers for docker run commands.
#
# [1]: https://github.com/jessfraz/dotfiles/blob/9ac223d3d866dc326701cf5b7b32b196177ec1f2/.dockerfunc
#
# Also inspired/copied from Andrew:
# https://raw.githubusercontent.com/andrewsardone/dotfiles/master/docker/.dockerfunc

#
# Helper Functions
# via jessfraz/dotfiles
#

docker-cleanup(){
  local containers
  containers=( $(docker ps -aq 2>/dev/null) )
  docker rm "${containers[@]}" 2>/dev/null
  local volumes
  volumes=( $(docker ps --filter status=exited -q 2>/dev/null) )
  docker rm -v "${volumes[@]}" 2>/dev/null
  local images
  images=( $(docker images --filter dangling=true -q 2>/dev/null) )
  docker rmi "${images[@]}" 2>/dev/null
}

docker-del-stopped(){
  local name=$1
  local state
  state=$(docker inspect --format "{{.State.Running}}" "$name" 2>/dev/null)

  if [[ "$state" == "false" ]]; then
    docker rm "$name"
  fi
}

docker-relies-on(){
  for container in "$@"; do
    local state
    state=$(docker inspect --format "{{.State.Running}}" "$container" 2>/dev/null)

    if [[ "$state" == "false" ]] || [[ "$state" == "" ]]; then
      echo "$container is not running, starting it for you."
      $container
    fi
  done
}

#
# Container Aliases
#

wpscan() {
  docker run -it --rm wpscanteam/wpscan -u "$@"
}
