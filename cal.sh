for iter in 1 2 3
do
    for SIZE in 1 4 8 16 32 64 128
    do
        cat /home/classact/kube-iperf3/result/${iter}-${SIZE}-*.log | grep receiver | cut -d "M" -f2 > /home/classact/kube-iperf3/result2/${iter}-${SIZE}-bandwidth.txt
        awk '{sum += $2; cnt++} END {print sum/cnt}' ./result2/${iter}-${SIZE}-bandwidth.txt > result2/${iter}-${SIZE}_average.txt
    done
done



for SIZE in 1 4 8 16 32 64 128
do
    cat /home/classact/kube-iperf3/result2/*-${SIZE}_average.txt > result2/result-${SIZE}
    awk '{sum += $1; cnt++} END {print sum/cnt}' ./result2/result-${SIZE}
done