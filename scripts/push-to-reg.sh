#!/bin/bash

# use until buildx is ready 


RED='\033[0;31m'
NC='\033[0m'

red_print () {
    echo -e "\n\n${RED}$1\n########################################################${NC}\n\n"
}

if [ -z "$1" ]
  then
    echo "No argument supplied. <user>@<ip> of build system required!"
    exit 1
fi

if [ -z "$2" ]
  then
    echo "No argument supplied. Password of build system required!"
    exit 1
fi

if [ -z "$3" ]
  then
    echo "No argument supplied. IP:PORT of registry required!"
    exit 1
fi

if [ -z "$4" ]
  then
    echo "No argument supplied. Absolute path of directory containing Dockerfile required!"
    exit 1
fi


check_dir_file () {
  MY_DIR=$1
  NODE_TYPE=$(stat -c '%F' ${MY_DIR} 2>/dev/null)
  # echo $NODE_TYPE
  case "${NODE_TYPE}" in
    "regular file")   return 1;;
    "directory")      return 2;;
    "symbolic link")  return 3;;
    "")               return 4;;
    *)                return 5;;
  esac
}

check_dir_file $4
if [ $? != 2 ] 
  then
    echo "not a dir"
    exit 1
fi

check_dir_file "$4/Dockerfile"
if [ $? != 1 ] 
  then
    echo "no Dockerfile"
    exit 1
fi

sudo apt install -y sshpass
container_name=$(basename $4)
sshpass -p$2 scp -r $4 $1:~/$container_name
sshpass -p$2 ssh -oStrictHostKeyChecking=no $1 "cd $container_name \
&& printf \"\n\nBUILDING $container_name\n\n\" \
&& echo \"docker build --progress plain -t $3/$container_name:arm .\" \
&& docker build --progress plain -t $3/$container_name:arm . \
&& printf \"\n\nPUSHING $container_name to $3/$container_name:arm\n\n\" \
&& echo \"docker push $3/$container_name:arm\" \
&& docker push $3/$container_name:arm"
