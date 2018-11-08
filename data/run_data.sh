brain_name=${5}
cell_type=${6}
cell_name=${7}
prefix=$(echo ${brain_name}_${cell_type}_${cell_name})

find processed_swc/Whole/${prefix}.processed.swc
if [ ! -f processed_swc/Whole/${prefix}.processed.swc ]
then
	# Preprocess
	if [ "${1}" == 1 ]
	then
		vaa3d -x preprocess -f preprocess -p "#i temp_dir/${prefix}.swc #o processed_swc/Whole/${prefix}.processed.swc #l 2 #s 0 #t 2 #m 20 #z 10 #r 0 #d 0 #f 0"
	fi

	# Step 2: QC
	if [ "${2}" == 1 ]
	then
		vaa3d -x preprocess -f qc -p "#i processed_swc/Whole/${prefix}.processed.swc #o processed_swc/Whole/${prefix}.processed"
		mv processed_swc/Whole/${prefix}.processed.QC.txt QC/separate_files
	fi
fi

# Step 3: Split
if [ "${3}" == 1 ]
then
vaa3d -x preprocess -f split_neuron -p "#i processed_swc/Whole/${prefix}.processed.swc"
mv processed_swc/Whole/${prefix}.processed*axon* processed_swc/Axon/
mv processed_swc/Whole/${prefix}.processed*dendrite* processed_swc/Dendrite/
vaa3d -x preprocess -f crop_swc -p "#i processed_swc/Dendrite/${prefix}.processed.dendrite.swc #r -1 #j -1 #c 1 #t 1"
vaa3d -x preprocess -f crop_swc -p "#i processed_swc/Axon/${prefix}.processed.long_axon.swc #r -1 #j -1 #c 1 #t 1"
vaa3d -x preprocess -f crop_swc -p "#i processed_swc/Axon/${prefix}.processed.axon.proximal_axon.swc #r -1 #j -1 #c 1 #t 1"
vaa3d -x preprocess -f crop_swc -p "#i processed_swc/Axon/${prefix}.processed.axon.distal_axon.swc #r -1 #j -1 #c 1 #t 1"
fi

# Step 4: Global features
if [ "${4}" == 1 ]
then
echo -e "${cell_name}\n${cell_type}" >temp_dir/${prefix}.dendrite.features
vaa3d -x global_neuron_feature -f compute_feature -i processed_swc/Dendrite/${prefix}.processed.dendrite.cropped.swc |grep ":" | awk -F ":" '{print $2}' |sed "s/^[[:space:]]*//" >>temp_dir/${prefix}.dendrite.features
echo -e "${cell_name}\n${cell_type}" >temp_dir/${prefix}.long_axon.features
vaa3d -x global_neuron_feature -f compute_feature -i processed_swc/Axon/${prefix}.processed.long_axon.cropped.swc |grep ":" | awk -F ":" '{print $2}' |sed "s/^[[:space:]]*//" >>temp_dir/${prefix}.long_axon.features
echo -e "${cell_name}\n${cell_type}" >temp_dir/${prefix}.proximal_axon.features
vaa3d -x global_neuron_feature -f compute_feature -i processed_swc/Axon/${prefix}.processed.axon.proximal_axon.cropped.swc |grep ":" | awk -F ":" '{print $2}' |sed "s/^[[:space:]]*//" >>temp_dir/${prefix}.proximal_axon.features
echo -e "${cell_name}\n${cell_type}" >temp_dir/${prefix}.distal_axon.features
vaa3d -x global_neuron_feature -f compute_feature -i processed_swc/Axon/${prefix}.processed.axon.distal_axon.cropped.swc |grep ":" | awk -F ":" '{print $2}' |sed "s/^[[:space:]]*//" >>temp_dir/${prefix}.distal_axon.features
fi
