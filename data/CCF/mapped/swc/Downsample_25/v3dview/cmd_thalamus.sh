echo "RAWIMG=average_template_25.nrrd.v3draw" >v3dview_thalamus.ano
for i in $(find /local1/Documents/Morph_analysis/data/temp_dir/17302_[LT]*swc |awk -F "17302_" '{print $2}' |sed "s/\.swc//" |awk -F "_" '{print $2}')
do
echo ${i}
swcfile=$(find 17302_$i*)
echo "SWCFILE=${swcfile}" >>v3dview_thalamus.ano
done
