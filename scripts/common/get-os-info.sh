#!/bin/bash 

getOSInfo () {
  printf "|||uname -a\n"
  uname -a
  printf "|||\n\n"
  
  printf "|||cat /etc/os-release\n"
  cat /etc/os-release
  printf "|||\n\n"

  printf "|||cat /proc/cpuinfo\n"
  cat /proc/cpuinfo
  printf "|||\n\n"

  printf "|||cat /proc/meminfo\n"
  cat /proc/meminfo
  printf "|||\n\n"

  printf "|||cat /proc/filesystems\n"
  cat /proc/filesystems
  printf "|||\n\n"
  
  printf "|||cat /proc/version\n"
  cat /proc/version
  printf "|||\n\n"
}

getOSInfo