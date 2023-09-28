-#################################-
----------**mysql分区+全中文模板**-------------
-#################################-

**项目地址**
[GitHub项目地址](https://github.com/NoYoWiFi/zabbix_docker)

**效果图**

```
[root@localhost zabbix_docker]# docker images
REPOSITORY               TAG                 IMAGE ID       CREATED        SIZE
zabbix-server-mysql      centos-6.0-latest   5bbe1784ca86   4 days ago     889MB
zabbix-web-service       centos-6.0-latest   302c32090933   4 days ago     732MB
zabbix-proxy-mysql       centos-6.0-latest   2af003bb178b   4 days ago     673MB
zabbix-java-gateway      centos-6.0-latest   6825b642100d   4 days ago     720MB
zabbix-snmptraps         centos-6.0-latest   d444eab79de1   4 days ago     601MB
zabbix-agent2            centos-6.0-latest   ddb84f925c55   4 days ago     615MB
mariadb                  10.5.19-focal       cfe0a83e48d5   8 days ago     392MB
zabbix-web-nginx-mysql   centos-6.0-latest   64081ecac82f   6 weeks ago    774MB
quay.io/centos/centos    stream8             6a97c47aacfc   3 months ago   513MB
[root@localhost zabbix_docker]# 
[root@localhost zabbix_docker]# docker ps -a
CONTAINER ID   IMAGE                                      COMMAND                  CREATED          STATUS                    PORTS                                                                            NAMES
977e75774418   zabbix-web-nginx-mysql:centos-6.0-latest   "docker-entrypoint.sh"   15 minutes ago   Up 15 minutes (healthy)   0.0.0.0:80->8080/tcp, :::80->8080/tcp, 0.0.0.0:443->8443/tcp, :::443->8443/tcp   zabbix_docker-zabbix-web-nginx-mysql-1
0770a23343e9   zabbix-server-mysql:centos-6.0-latest      "/usr/bin/tini -- /u…"   15 minutes ago   Up 15 minutes             0.0.0.0:10051->10051/tcp, :::10051->10051/tcp                                    zabbix_docker-zabbix-server-1
98aecf59d879   zabbix-agent2:centos-6.0-latest            "/usr/bin/tini -- /u…"   15 minutes ago   Up 15 minutes             0.0.0.0:10050->10050/tcp, :::10050->10050/tcp, 31999/tcp                         zabbix_docker-zabbix-agent2-1
ec9e9cd0ed74   zabbix-java-gateway:centos-6.0-latest      "docker-entrypoint.s…"   15 minutes ago   Up 15 minutes                                                                                              zabbix_docker-zabbix-java-gateway-1
d0d7d7977b99   zabbix-snmptraps:centos-6.0-latest         "/usr/sbin/snmptrapd…"   15 minutes ago   Up 15 minutes             0.0.0.0:162->1162/udp, :::162->1162/udp                                          zabbix_docker-zabbix-snmptraps-1
b72cdae7ba93   zabbix-web-service:centos-6.0-latest       "docker-entrypoint.s…"   15 minutes ago   Up 15 minutes                                                                                              zabbix_docker-zabbix-web-service-1
0b8819153360   mariadb:10.5.19-focal                      "docker-entrypoint.s…"   15 minutes ago   Up 15 minutes             0.0.0.0:3306->3306/tcp, :::3306->3306/tcp                                        zabbix_docker-mysql-server-1
[root@localhost zabbix_docker]# 

```

**集成全中文模板**

[外链图片转存失败,源站可能有防盗链机制,建议将图片保存下来直接上传(img-BEPZZYkn-1676860832869)(vx_images/356045610248677.png)]
![在这里插入图片描述](https://img-blog.csdnimg.cn/585028d8a0d44cbea96763b9b8cc9592.png#pic_center)

[外链图片转存失败,源站可能有防盗链机制,建议将图片保存下来直接上传(img-RdC733Z1-1676860832873)(vx_images/486755610236544.png)]
![在这里插入图片描述](https://img-blog.csdnimg.cn/8bb66268ed784fc69da7c57eba7ac20c.png#pic_center)

**执行如下命令进行git安装**

```
yum -y install git
```

**执行如下命令克隆docker安装中文版zabbix项目**

```
ZBX_SOURCES=https://NoYoWiFi:agp_66c5fe553765c414b8de0886f668b5f7@codeup.aliyun.com/636defa3f003e3b7bb5cae22/zabbix_docker/zabbix_chinese.git
ZBX_VERSION=6.0-latest
ZBX_NAME=zabbix_docker-${ZBX_VERSION}
ZBX_DIR=/opt
cd ${ZBX_DIR}
git -c advice.detachedHead=false clone ${ZBX_SOURCES} --branch ${ZBX_VERSION} --depth 1 --single-branch ${ZBX_DIR}/${ZBX_NAME}
chmod 755 -R ${ZBX_DIR}/${ZBX_NAME}
cd ${ZBX_DIR}/${ZBX_NAME}
```

**执行如下命令安装docker服务**

```
sh update_config-entrypoint_mysql.sh init
```

**执行如下命令下载docker镜像**

```
sh update_config-entrypoint_mysql.sh down
```

**执行如下命令初始化配置文件**

```
sh update_config-entrypoint_mysql.sh cp
```

**执行如下命令启动docker容器**

```
sh update_config-entrypoint_mysql.sh start
```

**打开网页输入服务器IP地址访问zabbix**
http://IP:8080 或 https://IP:8443
用户名: Admin
密码: zabbix

**打开网页输入服务器IP地址访问grafana**
https://IP:3000
用户名: admin
密码: admin

**zabbix-server服务器同时优化成了rsyslog日志服务器，rsyslog日志端口为514**
日志存储路径为 /var/log/loki/

**grafana优化集成了zabbix与Loki插件**
请将任意.log后缀日志存入 /var/log/loki/即可连接到loki
URL为http://IP:3100
![在这里插入图片描述](https://img-blog.csdnimg.cn/e6c1805fdf054b1080066002c64bee17.png)

**存储位置**

映射的卷位于当前文件夹的zbx_env目录

**zabbix-server配置文件位置**
`/opt/zabbix_docker-6.0-latest/env_vars/.env_srv`

**后期如果有新版本发布可以通过如下命令更新zabbix版本**

```
sh update_config-entrypoint_mysql.sh stop

ZBX_SOURCES=https://NoYoWiFi:agp_66c5fe553765c414b8de0886f668b5f7@codeup.aliyun.com/636defa3f003e3b7bb5cae22/zabbix_docker/zabbix_chinese.git
ZBX_VERSION=6.0-latest
ZBX_NAME=zabbix_docker-${ZBX_VERSION}
ZBX_DIR=/opt
cd ${ZBX_DIR}
git -c advice.detachedHead=false pull ${ZBX_SOURCES} --branch ${ZBX_VERSION} --depth 1 --single-branch ${ZBX_DIR}/${ZBX_NAME}
chmod 755 -R ${ZBX_DIR}/${ZBX_NAME}
cd ${ZBX_DIR}/${ZBX_NAME}

sh update_config-entrypoint_mysql.sh down

sh update_config-entrypoint_mysql.sh start
```


**全文完结**