#!/usr/bin/env bash

## This program has two feature.
#
# 1. Create a disk image on RAM.
# 2. Mount that disk image.
#
# Usage:
#   $0 <dir> <size>
#
#   size:
#     The `size' is a size of disk image (MB).
#
#   dir:
#     The `dir' is a directory, the dir is used to mount the disk image.
#
# See also:
#   - hdid(8)
#
mount_in_ram() {
  mount_point=${1}
  size=${2:-64}

  mkdir -p $mount_point
  if [ $? -ne 0 ]; then
      echo "The mount point didn't available." >&2
      exit $?
  fi

  sector=$(expr $size \* 1024 \* 1024 / 512)
  device_name=$(hdid -nomount "ram://${sector}" | awk '{print $1}')
  if [ $? -ne 0 ]; then
      echo "Could not create disk image." >&2
      exit $?
  fi

  newfs_hfs $device_name > /dev/null
  if [ $? -ne 0 ]; then
      echo "Could not format disk image." >&2
      exit $?
  fi

  mount -t hfs $device_name $mount_point
  if [ $? -ne 0 ]; then
      echo "Could not mount disk image." >&2
      exit $?
  fi
}

# This program has two features.
#
# 1. Unmount a disk image.
# 2. Detach the disk image from RAM.
#
# Usage:
#   $0 <dir>
#
#   dir:
#     The `dir' is a directory, the dir is mounting a disk image.
#
# See also:
#   - hdid(8)
#
umount_from_ram() {
  mount_point=$1
  if [ ! -d "${mount_point}" ]; then
      echo "The mount point didn't available." >&2
      exit 1
  fi
  mount_point=$(cd $mount_point && pwd)

  device_name=$(df "${mount_point}" 2>/dev/null | tail -1 | grep "${mount_point}" | cut -d' ' -f1)
  if [ -z "${device_name}" ]; then
      echo "The mount point didn't mount disk image." >&2
      exit 1
  fi

  umount "${mount_point}"
  if [ $? -ne 0 ]; then
      echo "Could not unmount." >&2
      exit $?
  fi

  hdiutil detach -quiet $device_name
}


gen_psw() {
  LC_ALL=C tr -dc "[=!=][=?=][=.=][:alnum:]" < /dev/urandom | head -c ${1:-30} | pbcopy
}

ip() {
    ifconfig | grep inet | grep -v inet6 | awk '{print $2}'
}

gzip_size () {
  gzip -c $1 | wc -c
}

git_update_all_branches() {
  current_branch=$(git rev-parse --abbrev-ref HEAD);
  for BRANCH in `git branch --list|sed 's/\*//g'`;
  do
    git checkout $BRANCH;
    git bup;
  done;
  git checkout $current_branch;
}

pr (){
  open-pr ${1-master}
}
