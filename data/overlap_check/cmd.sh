# Create list for comparison
cellid=$(echo ${1})
if [ -f n1_list ];then rm n1_list;fi
for i in $(find Level2/${cellid}/*swc | awk -F "/" '{print $3}' | awk -F "_" '{print $2}' )
do
	if [ ! -f n1_list ];
	then 
		echo ${i} >n1_list;
	else
		echo ${i} >>n1_list;
	fi
done
cat n1_list >n2_list

# Run pair-wise overlapping test
if [ ! -e ANO/${cellid} ];then mkdir ANO/${cellid};fi
if [ ! -e APO/${cellid} ];then mkdir APO/${cellid};fi
if [ ! -e overlap_stats/${cellid} ];then mkdir overlap_stats/${cellid};fi

echo "names" >run.log 
while read n1
do
while read n2
do
if [ ${n1} \< ${n2} ]
then
	input1=$(find Level2/${cellid}/${cellid}_${n1}*swc | awk -F "/" '{print $3}')
	input2=$(find Level2/${cellid}/${cellid}_${n2}*swc | awk -F "/" '{print $3}')
	output="${n1}_${n2}"
	if [ ! -f overlap_stats/${cellid}/${output}.txt ]
	then
		while [ 1 -eq 1 ]
		do
			n_proc=$(grep procs_running /proc/stat|awk -F " " '{print $2}')
			cpu_idle=$(top -b -n 1 |grep ^%Cpu |awk -F  " " '{print $8}')
			#ready_to_run=$(echo "${cpu_idle} > 50" |bc -l)
			ready_to_run=$(echo "${n_proc} < 32" |bc -l)
			if [ "${ready_to_run}" -eq 1 ]
			then
				echo ${output} ${n_proc} >>run.log
				vaa3d -x neuron_overlap -f overlap -i Level2/${cellid}/${input1} Level2/${cellid}/${input2} -p 2 "APO/${cellid}/${output}.apo" -o "overlap_stats/${cellid}/${output}.txt" &
				break
			else
				sleep 10s
				n_proc=$(grep procs_running /proc/stat|awk -F " " '{print $2}')
                        	ready_to_run=$(echo "${n_proc} < 32" |bc -l)
			fi
		done
	fi
fi
done < n2_list
done < n1_list

