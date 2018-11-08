for i in $(find *apo)
do 
prefix=$(echo ${i} |sed "s/\apo/soma/")
echo ${profile}
vaa3d -x reconstruction_IO -f convert -i ${i} -p apo swc
done
