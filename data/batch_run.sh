config_file=${1}
cell_type=${2}

run_preprocess=1
run_qc=1
run_split=1
run_feature=1

# From config_file we get: brain_name, swc_prefix and soma_path
source ${config_file}
swc_path=$(echo ${swc_prefix}${cell_type})

if [ ! -e "processed_swc" ]; then mkdir processed_swc; fi
for cell_name in $(ls -lSr ${swc_path}/*swc |awk -F " " '{print $10}' |awk -F "/" '{print $NF}'|awk -F "_" '{print $2}')
do
	prefix=$(echo ${brain_name}_${cell_type}_${cell_name})
	sh prepare_data.sh ${swc_path} ${soma_path} ${brain_name} ${cell_type} ${cell_name} 
	
	# Run pipeline of one cell
	while [ 1 -eq 1 ]
	do
		n_proc=$(grep procs_running /proc/stat|awk -F " " '{print $2}')
		ready_to_run=$(echo "${n_proc} < 32" |bc -l)
		if [ "${ready_to_run}" -eq 1 ]
		then
			sh run_data.sh ${run_preprocess} ${run_qc} ${run_split} ${run_feature} ${brain_name} ${cell_type} ${cell_name} &
			break
		else
			sleep 10s
		fi
	done
done

while [ 1 -eq 1 ]
do
running_jobs=$(jobs|wc -l)
if [ "${running_jobs}" -eq 0 ]
then
	#QC
	if [ "${run_qc}" -eq 1 ];then sh combine_qc.sh ${config_file} ${cell_type};fi
	#Features
        if [ "${run_feature}" -eq 1 ];then sh combine_features.sh ${config_file} ${cell_type};fi
	break	
else
	echo "Jobs running:"${running_jobs}
	jobs
	sleep 3s
fi
done

