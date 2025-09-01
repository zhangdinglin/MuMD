#这个文件夹下的pdb是为了重复 之前的combdock 和multi_lzd 
#只做对接不做原子补全，

#第一步: 准备数据
MYDIR="/home/zhangdinglin/zdl_bin/MuMD_project_test"
MYdata="/home/zhangdinglin/zdl_bin/MuMD_project_test/data_test"

#1) 整理所有复合物pdb文件，只保留必要的链，放到${MYdata}中。所有的复合物pdb文件放在一个列表中 list, 内容类似
1a0r.pdb  
1du3.pdb  
1es7.pdb  
1gpq.pdb
#2) 为每一个符合物建立一个文件夹
cat list |while read f;do echo ${f:0:4}; mkdir ${f:0:4}; mv $f ${f:0:4};done
#3) 拆分每一个复合物得到组装单体
cat list |while read f;do  cd ${f:0:4} ;sh ${MYDIR}/split_by_chain_id.sh $f;cd ..;done

#产生对对 对接的初始文件夹，下面的脚本只能产生一个pdb的. 参数链条要确认好。 
cd ${MYdata}/1a0r;nohup sh -x  ~/zdl_bin/set_dock_dir.sh BGP  1>ok 2>ng &
cd ${MYdata}/1du3;nohup sh -x  ~/zdl_bin/set_dock_dir.sh ABCDEF  1>ok 2>ng &
cd ${MYdata}/1es7;nohup sh -x  ~/zdl_bin/set_dock_dir.sh ABCD  1>ok 2>ng &
cd ${MYdata}/1gpq;nohup sh -x  ~/zdl_bin/set_dock_dir.sh ABCD  1>ok 2>ng &


