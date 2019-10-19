RED='\033[0;31m'
NC='\033[0m'

red_print () {
    echo -e "\n\n${RED}$1\n########################################################${NC}\n"
}

if [ -z "$1" ]; then
    echo "No argument supplied. IP of balenaOS required!"
    exit 1
fi

if [ -z "$2" ]; then
    echo "No argument supplied. IP of hypriotOS required!"
    exit 1
fi

if [ -z "$3" ]; then
    echo "No argument supplied. IP of rancherOS required!"
    exit 1
fi

if [ -z "$4" ]; then
    echo "No argument supplied. IP of raspbian-lite required!"
    exit 1
fi

red_print "Cleaning balena"
ssh -oStrictHostKeyChecking=no -p 22222 root@$1 "balena system prune --all -f"

red_print "Cleaning hypriot"
sshpass -phypriot ssh -oStrictHostKeyChecking=no pirate@$2 "docker system prune --all -f"

red_print "Cleaning rancher"
sshpass -prancher ssh -oStrictHostKeyChecking=no rancher@$3 "docker system prune --all -f"

red_print "Cleaning rasbian"
sshpass -praspberry ssh -oStrictHostKeyChecking=no pi@$4 "docker system prune --all -f"