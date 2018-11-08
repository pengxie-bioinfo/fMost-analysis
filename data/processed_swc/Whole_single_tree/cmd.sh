for i in $(find ../Whole/*processed.swc)
do
outfile=$(echo ${i}|awk -F "/" '{print $3}')
awk -F " " '{if($2!=7)print $0}' ${i} >${outfile}
done

for i in $(find ../Whole/*processed.ano)
do
outfile=$(echo ${i}|awk -F "/" '{print $3}')
#grep SWCFILE ${i} >${outfile}
done
