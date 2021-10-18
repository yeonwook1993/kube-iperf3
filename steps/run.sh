#!/usr/bin/env bash
iter=$1
set -eu

CLIENTS=$(kubectl get pods -l app=iperf3-client -o name | cut -d'/' -f2)

echo "Waiting for all client Ready..."
for POD in ${CLIENTS}; do
    until $(kubectl get pod ${POD} -o jsonpath='{.status.containerStatuses[0].ready}'); do
        sleep 2
    done
done

HOSTS=$(kubectl --kubeconfig /home/classact/kube-iperf3/kubeconfig.cluster-b get pods -l app=iperf3-server -o yaml | grep 'podIP' -w | cut -d ":" -f2)

 

for SIZE in 1 4 8 16 32 64 128
do
    index=1
    for POD in ${CLIENTS}; do
        HOST=$(echo $HOSTS | cut -d " " -f$index)
        kubectl exec ${POD} -- iperf3 -c ${HOST} -w ${SIZE}k -f m -t 60 > /home/classact/kube-iperf3/result/${iter}-${SIZE}-${index}.log &
        index=`expr $index + 1`
    done
    echo "Running iperf3 process..."
    while [ -n "$(ps | grep kubectl)" ]
    do
        sleep 1
    done
done