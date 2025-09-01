#call method : sh ~/zdl_bin/dock_complex_merge_N.sh pdb ABC  N     #参数2表示链的列表， 参数3表示每一次生长保留候选结构的数量。
#文件夹必须重新建立才可以。

pdb=$1
chains=$2
N=$3



for i in `seq  1 $N`;do cp -a ${pdb} ${pdb}_$i;cd ${pdb}_$i; sh  ~/zdl_bin/dock_complex_merge.sh ${chains} 3 1>ok 2>ng ;cd ..;done

