#param1 all chainID    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"


MYDIR="/home/zhangdinglin/zdl_bin/MuMD_project_test"

#alai="ABCEFHIJKL"
alai=$1

for ((i=0;$i+1<=${#alai};i=$i+1));
do
	for ((j=$i+1;$j+1<=${#alai};j=$j+1));
	do
                n1=${alai:$i:1}
                n2=${alai:$j:1}
                nd=zdock_${n1}""${n2}
		echo $nd
                cp -a ${MYDIR}/zdock302_scr_surf13 $nd
                cd $nd
                ln -s ../${n1}.pdb  receptor.pdb
		ln -s ../${n2}.pdb  ligand.pdb
		cd ..
                 
	done
done

