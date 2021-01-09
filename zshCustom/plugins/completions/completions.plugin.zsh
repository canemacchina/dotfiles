_pr () {
  branches=($(git branch -r --list \*VR-\*))
  arguments=()
  for branch in "${branches[@]}"; do
    arguments+=(${branch##*/})
  done
  arguments+=("master")
  unset branches
  _values '' $arguments && ret=0
  unset arguments
  return ret
}

_git-co () {
  branches=($(git branch -r --list \*VR-\*))
  arguments=()
  for branch in "${branches[@]}"; do
    arguments+=("$( echo $branch | egrep -o 'VR-[0-9]+' | cut -c 4-)[$branch]")
  done
  arguments+=("master[master]")
  unset branches
  _values '' $arguments && ret=0
  unset arguments
  return ret
}

_git-start () {
  if (( CURRENT == 3 )); then
    branches=($(git branch -r | grep -v "origin/HEAD"))
    _values '' $branches && ret=0
    unset branches
  fi
  return ret
}

_git-ron () {
  _git-checkout
}

_git-bclean () {
  _git-checkout
}

_git-bdone () {
  _git-checkout
}

compdef _pr pr
compctl -g '~/.itermocil/*(:t:r)' itermocil
