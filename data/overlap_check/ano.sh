cellid=${1}
while read n1
do
while read n2
do
	if [ ${n1} \< ${n2} ]
	then
        	input1=$(find Level2/${cellid}/${cellid}_${n1}*swc | awk -F "/" '{print $3}')
        	input2=$(find Level2/${cellid}/${cellid}_${n2}*swc | awk -F "/" '{print $3}')
        	output="${n1}_${n2}"

        	if [ -f APO/${cellid}/${output}.apo ]
        	then
                	echo ${n1} ${n2}
                	echo "SWCFILE=../../Level2/${cellid}/${input1}" >"ANO/${cellid}/${output}.ano"
                	echo "SWCFILE=../../Level2/${cellid}/${input2}" >>"ANO/${cellid}/${output}.ano"
                	echo "APOFILE=../../APO/${cellid}/${output}.apo" >>"ANO/${cellid}/${output}.ano"
        	fi
	fi
done < n2_list
done < n1_list

