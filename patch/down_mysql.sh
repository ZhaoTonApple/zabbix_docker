GV_VERSION=$(cat ./patch/.version_docker)
VERSION=centos-${GV_VERSION}
ADDRESS=registry.cn-shanghai.aliyuncs.com/zabbix_docker/zabbix_chinese
for IM in `cat ./patch/.images_mysql`
do
docker pull ${ADDRESS}:${IM}_${VERSION}
docker tag ${ADDRESS}:${IM}_${VERSION} ${IM}:${VERSION}
docker rmi ${ADDRESS}:${IM}_${VERSION}
done
docker pull ${ADDRESS}:centos_stream8
docker tag ${ADDRESS}:centos_stream8 quay.io/centos/centos:stream8
docker rmi ${ADDRESS}:centos_stream8
docker pull ${ADDRESS}:mariadb
docker tag ${ADDRESS}:mariadb mariadb:10.11.2
docker rmi ${ADDRESS}:mariadb
docker pull ${ADDRESS}:grafana_grafana-enterprise
docker tag ${ADDRESS}:grafana_grafana-enterprise grafana/grafana-enterprise:10.1.0
docker rmi ${ADDRESS}:grafana_grafana-enterprise