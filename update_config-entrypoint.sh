#!/bin/bash
###
### hello to use the shell
###
### Usage:
###
###    sh update_config-entrypoint.sh [start|stop|restart|rm]
###
###
### Options:
###   help        Show this message.

# 设置了这个选项以后，包含管道命令的语句的返回值，会变成最后一个返回非零的管道命令的返回值。
set -o pipefail

# 执行的时候如果出现了返回值为非零将会继续执行下面的脚本
set +e

# Script trace mode
set -o xtrace

GV_VERSION_DOCKER=$(cat ./patch/.version_docker)

help() {
	awk -F'### ' '/^###/ { print $2 }' "$0"
}

init() {
sed -i -e "/:centos-/s/:centos-.*/:centos-${GV_VERSION_DOCKER}/" docker-compose_v6_0_x_centos_mysql_local.yaml
chmod 755 -R ./
option=$(cat /etc/redhat-release | cut -c 22)
if [[ " " == "${option}" ]]; then
	option=$(cat /etc/redhat-release | cut -c 23)
fi
case ${option} in
    8)
    echo "Centos 8 catch!"
    if [ ! -d "/etc/yum.repos.d/bak/" ]; then
        yum install -y yum-utils \
            device-mapper-persistent-data \
            lvm2
        yum-config-manager \
            --add-repo \
            https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/docker-ce.repo
        yum -y install docker-ce docker-ce-cli containerd.io --allowerasing
        yum -y install git
    fi
    ;;
    7)
    echo "Centos 7 catch!"
        yum install -y yum-utils \
            device-mapper-persistent-data \
            lvm2
        yum-config-manager \
            --add-repo \
            https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/docker-ce.repo
        yum -y install docker-ce docker-ce-cli containerd.io
        yum -y install git
    ;;
    *)
    echo "Nothing to do"
    ;;
esac
service docker start
touch /etc/docker/daemon.json
cat > /etc/docker/daemon.json << EOF
{
  "registry-mirrors": ["https://xb10bnbv.mirror.aliyuncs.com"]
}
EOF
service docker restart
chmod 777 /var/run/docker.sock
if [ ! -f "/usr/local/bin/docker-compose" ]; then
    # curl -SL https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    \cp ./patch/docker-compose-linux-x86_64 /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi
systemctl enable docker
}


#################################################
if [ $# -eq 0 ]; then
    help
    exit 1
elif [ $# -ge 1 ]; then
    if [[ $1 == "help" ]]; then
    #    echo "**** Configuration file '$config_path' does not exist"
        help
        exit 1
    fi
      
    if [[ "$1" == "start" ]]; then
        option=$(echo ${GV_VERSION_DOCKER} | cut -c 1)
        case ${option} in
            5)
            echo "zabbix 5 LTSC!"
            docker-compose -f docker-compose_v6_0_x_centos_mysql_local.yaml --profile=start5 up -d
            ;;
            6)
            echo "zabbix 6 LTSC!"
            docker-compose -f docker-compose_v6_0_x_centos_mysql_local.yaml --profile=start6 up -d
            ;;
            *)
            echo "Nothing to do"
            ;;
        esac
        exit 1
    fi
    
    if [[ "$1" == "stop" ]]; then
        docker-compose -f docker-compose_v6_0_x_centos_mysql_local.yaml stop
        exit 1
    fi
    
    if [[ "$1" == "restart" ]]; then
        docker-compose -f docker-compose_v6_0_x_centos_mysql_local.yaml restart
        exit 1
    fi
    
    if [[ "$1" == "rm" ]]; then
        docker-compose -f docker-compose_v6_0_x_centos_mysql_local.yaml rm
        exit 1
    fi
	
    if [[ "$1" == "down" ]]; then
        sh ./patch/down.sh
        exit 1
    fi
	
    if [[ "$1" == "init" ]]; then
        init
        exit 1
    fi
fi

#################################################
