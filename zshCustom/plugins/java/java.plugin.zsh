#!/usr/bin/env zsh

java_home='/usr/libexec/java_home'
GLOBAL_JAVA_VERSION_FILE=~/.java_version
[ -r "$GLOBAL_JAVA_VERSION_FILE" ] && [ -f "$GLOBAL_JAVA_VERSION_FILE" ] && source "$GLOBAL_JAVA_VERSION_FILE";

jvm() {
  case "$1" in
    list) $java_home -V ;;
    local) use_jvm $2 ;;
    global) use_jvm_global $2 ;;
    *) $java_home -V ;;
  esac
}

print_java_version() {
  echo "using java $(java -version 2>&1 | head -1 | cut -d'"' -f2 | sed 's/^1\.//' | cut -d'.' -f1)"
}

get_new_java_version() {
  unset JAVA_HOME
  echo $(/usr/libexec/java_home -v$1)
}

use_jvm() {
  export JAVA_HOME=$(get_new_java_version $1)
  print_java_version
}

use_jvm_global() {
  echo "export JAVA_HOME=$(get_new_java_version $1)" > $GLOBAL_JAVA_VERSION_FILE
  source $GLOBAL_JAVA_VERSION_FILE
  print_java_version
}

_jvm() {
  if (( CURRENT == 2 )); then
    compadd list local global
  fi
  if (( CURRENT == 3 )); then
    local arguments=()
    jvm list 2>&1 | head -n -1 | tail -n +2 | while IFS= read -r line ; do
      local v=$(echo $line | cut -d'"' -f1 | cut -d"." -f1 | cut -d" " -f5)
      arguments+=(${v##*/})
    done
    _values '' $arguments && ret=0
  fi
  return ret
}

compdef _jvm jvm
