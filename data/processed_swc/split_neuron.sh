for i in $(find Whole/*processed.swc )
do
	id=$(echo ${i} | awk -F "/" '{print $2}' |sed "s/\.swc//")
	echo ${id}
	vaa3d -x preprocess -f split_neuron -p "#i ${i}"
	mv Whole/${id}*axon* Axon/
	mv Whole/${id}*dendrite* Dendrite/
	vaa3d -x preprocess -f crop_swc -p "#i Dendrite/${id}.dendrite.swc #r -1 #j -1 #c 1 #t 1"
	vaa3d -x preprocess -f crop_swc -p "#i Axon/${id}.long_axon.swc #r -1 #j -1 #c 1 #t 1"
	vaa3d -x preprocess -f crop_swc -p "#i Axon/${id}.axon.proximal_axon.swc #r -1 #j -1 #c 1 #t 1"
	vaa3d -x preprocess -f crop_swc -p "#i Axon/${id}.axon.distal_axon.swc #r -1 #j -1 #c 1 #t 1"
done  
