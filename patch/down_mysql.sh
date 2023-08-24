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
docker pull ${ADDRESS}:10.11.2
docker tag ${ADDRESS}:10.11.2 mariadb:10.11.2
docker rmi ${ADDRESS}:10.11.2
docker pull ${ADDRESS}:grafana_grafana-oss
docker tag ${ADDRESS}:grafana_grafana-oss grafana/grafana-oss:10.0.0
docker rmi ${ADDRESS}:grafana_grafana-oss