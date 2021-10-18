#!/usr/bin/env bash
set -eu

_target=result

if [ "$(ls -A "$_target" 2> /dev/null)" == "" ]; then
    echo "Start Script..."
else 
    echo "Remove Before Result..."
    # find "$_target" -exec rm {} \;
    rm -rf $_target/*
    echo "Start Script..."
    
fi

kubectl apply -f iperf3.yaml

for i in 1
do
    steps/run.sh $i
done