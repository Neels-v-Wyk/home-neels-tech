# adapted from https://github.com/PragmaticEngineering/kubespray-docker

IMAGE_TAG="v2.23.1"

docker pull quay.io/kubespray/kubespray:$IMAGE_TAG
docker run --rm -it \
    -v $PWD/ansible/inventory:/inventory \
    -v $HOME/.ssh/id_rsa:/root/.ssh/id_rsa \
    -v $PWD/scripts/kubespray:/scripts \
    quay.io/kubespray/kubespray:$IMAGE_TAG bash -c "/scripts/generate-inventory.sh $KUBERNETES_CLUSTER_NAME $KUBESPRAY_IPS; /scripts/cluster.sh $KUBERNETES_CLUSTER_NAME"
