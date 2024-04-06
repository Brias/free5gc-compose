#!/bin/bash
TAG=${1-"local-free5gc"}

NF_LIST="nrf amf smf udr pcf udm nssf ausf n3iwf upf chf"

readonly script_dir=$(dirname "$0")
echo ${script_dir}
cd "${script_dir}/../base"

rm -rf free5gc
cp -r /home/matthias/Projects/free5gc_/free5gc/ ./

make -C ./free5gc all

cd ../

make all
docker compose -f docker-compose-build.yaml build

for NF in ${NF_LIST}; do
    docker tag free5gc-compose-free5gc-${NF}:latest local-free5gc/${NF}:${TAG}
done


docker tag free5gc-compose-free5gc-webui:latest free5gc/webui:${TAG}
docker tag free5gc-compose-ueransim:latest free5gc/ueransim:${TAG}
docker tag free5gc-compose-n3iwue:latest free5gc/n3iwue:${TAG}
