# For each machine


ETCD_VERSION=v3.0.0
TOKEN=etcd-token
CLUSTER_STATE=new
NAME_1="etcd-0"
NAME_2="etcd-1"
NAME_3="etcd-2"
HOST_1=10.101.0.22
HOST_2=10.101.0.21
HOST_3=10.101.0.23
CLUSTER=${NAME_1}=http://${HOST_1}:2380,${NAME_2}=http://${HOST_2}:2380,${NAME_3}=http://${HOST_3}:2380
LISTEN_IP=0.0.0.0
DATA_DIR=/var/local/etcd


# For node 1
#if [ ! -d "$DATA_DIR" ]; then
#    sudo mkdir $DATA_DIR
#fi

function etcd1() {
THIS_NAME=${NAME_1}
THIS_IP=${HOST_1}
sudo docker run -d -v $DATA_DIR:/data -p 2379:2379 -p 2380:2380 --name etcd quay.io/coreos/etcd:${ETCD_VERSION} \
    /usr/local/bin/etcd \
    --data-dir=/data --name ${THIS_NAME} \
    --initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://${LISTEN_IP}:2380 \
    --advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://${LISTEN_IP}:2379 \
    --initial-cluster ${CLUSTER} \
    --initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}
}

# For node 2
function etcd2() {
THIS_NAME=${NAME_2}
THIS_IP=${HOST_2}
sudo docker run -d -v $DATA_DIR:/data -p 2379:2379 -p 2380:2380 --name etcd quay.io/coreos/etcd:${ETCD_VERSION} \
    /usr/local/bin/etcd \
    --data-dir=/data --name ${THIS_NAME} \
    --initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://${LISTEN_IP}:2380 \
    --advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://${LISTEN_IP}:2379 \
    --initial-cluster ${CLUSTER} \
    --initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}
}

# For node 3
function etcd3() {
THIS_NAME=${NAME_3}
THIS_IP=${HOST_3}
sudo docker run -d -v $DATA_DIR:/data -p 2379:2379 -p 2380:2380 --name etcd quay.io/coreos/etcd:${ETCD_VERSION} \
    /usr/local/bin/etcd \
    --data-dir=/data --name ${THIS_NAME} \
    --initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://${LISTEN_IP}:2380 \
    --advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://${LISTEN_IP}:2379 \
    --initial-cluster ${CLUSTER} \
    --initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}
}


$*
