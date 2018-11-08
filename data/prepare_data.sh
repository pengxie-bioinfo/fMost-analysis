swc_path=${1} 
soma_path=${2}
brain_name=${3}
cell_type=${4} 
cell_name=${5}

cp $(find ${swc_path}/${brain_name}_${cell_name}*swc | grep -v "minification" |awk -F " " '{if(NR==1)print $1}') temp_dir/${brain_name}_${cell_type}_${cell_name}.swc
cell_no=$(echo ${cell_name} | sed 's/^0*//g')
awk -F "," -v x=${cell_no} '{if($3==x)print $0}' ${soma_path} >temp_dir/${brain_name}_${cell_type}_${cell_name}.apo
