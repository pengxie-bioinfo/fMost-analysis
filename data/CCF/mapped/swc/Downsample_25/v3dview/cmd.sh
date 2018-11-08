for i in $(find ../17302_*swc)
do
echo ${i}
swcfile=$(echo ${i} | awk -F "/" '{print $2}')
vaa3d -x resample_swc -f resample_swc -i ../${swcfile} -p 0.3 -o ${swcfile}
done
# vaa3d -x linker_file_generator -f linker -i v3dview -o v3dview.ano -p 7

# ANO file
echo "RAWIMG=average_template_25.nrrd.v3draw" >v3dview.ano
for i in $(find 17302*swc)
do
echo ${i}
echo "SWCFILE=${i}" >>v3dview.ano
done


