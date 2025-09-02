#这个文件夹下的pdb是为了重复 之前的combdock 和multi_lzd 
#只做对接不做原子补全，

MYDIR="/home/zhangdinglin/zdl_bin/MuMD_project_test"
MYdata="/home/zhangdinglin/zdl_bin/MuMD_project_test/data_test/1a0r"

cd ${MYdata}
#第二步: 组装
#call method : sh ${MYDIR}/dock_complex_merge.sh BGP N
#文件夹必须重新建立才可以，因为ABCDE  是兼并的， 可能是 AB_CDE   也可能是ABC_DE...

echo "">tmp_f_all
echo "">seed_str_all
mkdir  submov  #保存中间产生的subcomplex
chains=$1
Lc=${#chains}
N=$2      #保留topN个构象 参与构象选择的轮盘赌
#迭代看链条数，每次减少一个   #zdock 文件夹 完成对接。 第一个种子就默认是第一个chain
#cd $1;


#先找最大的种子，然后开始对接。也就是先要完成二级对接后才能进行后续高阶组装。
if [ 1 -eq 1 ];then
 for z in  zdock_??;
 do
        cd $z;
        if [ ! -f zdock.out ];then sh ${MYDIR}/run_zdock.sh 1>ok 2>ng;fi
        echo -n  "$z  1 "; head -n 6 zdock.out|tail -n 1;

        cd ..;
 done  >tmp_f1  #看打分 #取每个pdb 二体对接的最高分结构作为种子 做后续生长。


 seeddir=` cat tmp_f1|sort -rnk 9 |awk '{if(NR==1)print $1}' `  #只确定了文件夹，然后从中取出topN个结构
 ((l1=6,l2=6+N-1)); sed -n "${l1},${l2}p" ${seeddir}/zdock.out|awk '{sc_array[NR]=$7;sc_sum+=$7;}
 END{
               for(i=1;i<=NR;i++){scn_array[i]=sc_array[i]/sc_sum; }   #标注化
               for(i=1;i<=NR;i++){scn_accum_tmp +=scn_array[i]; scn_accum[i]= scn_accum_tmp; }    #标注化累加 做轮盘
               scn_accum[0]=0;  #数组元素一共NR+1
               srand();rnum=rand();for(i=1;i<=NR;i++){if(rnum >=scn_accum[i-1] && rnum<scn_accum[i]) {print i }}   #标注化
 }'  >seed_str1


 #将轮盘赌结构作为seed 同时记录其链构成
 rank=`awk '{print $1}' seed_str1`
 seed=${seeddir: -2}
 cp -rf $seeddir"/complex.${rank}.pdb" ./${seed}.pdb
 mv ${seed:0:1}.pdb ${seed:1:1}.pdb submov #然后删除submov
fi

#sleep 100
##############################################################################################################

for ((k=1;$k<${Lc};k=$k+1)) #
do
    sublist=`ls *.pdb`
    array=($sublist)
    L=${#array[@]}
    for ((i=0;i<L;i++)) #in "${!array[@]}"; do echo "$i=>${array[i]}";done
    do
        for ((j=i+1;j<L;j++))
        do
                n1=${array[i]::-4}
                n2=${array[j]::-4}
                nd=zdock_${n1}""${n2}


                #计算n1 n2公共字符数量  n1 n2 不可以有公共字符
                ((n_com=0));
                for ((p=0;p<${#n1};p++))
                do
                    if [[ ${n2} =~ ${n1:p:1}  ]] ;then ((n_com++));fi
                done


                if [[ $n_com -gt 0 ]] #不包含 就建立文件夹
                then
                    sleep 1
                else
                    #echo -n "${nd} "${n1}" "${n2}
                    if [ ! -d $nd ];then cp -a ${MYDIR}//zdock302_scr_surf13  $nd;fi
                    cd $nd
                    ln -s ../${array[i]}  receptor.pdb
                    ln -s ../${array[j]}  ligand.pdb
                    if [ ! -f zdock.out ];then sh run_zdock.sh 1>ok 2>ng;fi #run zdock
                    #awk -v az="${nd} ${n1} ${n2}" -v aN=$N 'BEGIN{s=0}{if(NF==7 && s<aN){print az,s+1, $0;s++}}' zdock.out  #输出N个结构分数
                    echo -n  "${nd} ${n1} ${n2}  1 "; head -n 6 zdock.out|tail -n 1;
                    cd ..
                fi
        done
    done  >tmp_f  #看打分 #取每个pdb 二体对接的最高分结构作为种子 做后续生长。
    cat tmp_f >>tmp_f_all ;echo "next step">>tmp_f_all
sleep 1
    #改成轮盘赌选择一个好的结构
#    cat tmp_f|sort -rnk 11 |awk '{sc_array[NR]=$11;sc_sum+=$11;line[NR,1]=$1;line[NR,2]=$2;line[NR,3]=$3;line[NR,4]=$4;}

    seeddir=` cat tmp_f|sort -rnk 11 |awk '{if(NR==1){print $1} }' `  #只确定了文件夹，然后从换个文件夹中取出topN个结构
    ((l1=6,l2=6+N-1)); sed -n "${l1},${l2}p" ${seeddir}/zdock.out|awk '{sc_array[NR]=$7;sc_sum+=$7;}
    END{
        for(i=1;i<=NR;i++){scn_array[i]=sc_array[i]/sc_sum; }   #标注化
        for(i=1;i<=NR;i++){scn_accum_tmp +=scn_array[i]; scn_accum[i]= scn_accum_tmp; }    #标注化累加 做轮盘
        scn_accum[0]=0;  #数组元素一共NR+1
        srand();rnum=rand();for(i=1;i<=NR;i++){if(rnum >=scn_accum[i-1] && rnum<scn_accum[i]) print i }   #标注化

    }'  >seed_str
    cat seed_str>>seed_str_all;echo "next step">>seed_str_all
sleep 10
    #将轮盘赌结构作为seed 同时记录其链状态
    seed=`cat tmp_f|sort -rnk 11 |awk '{if(NR==1){print $2} }' `
    lig_s=`cat tmp_f|sort -rnk 11 |awk '{if(NR==1){print $3} }' `
    rank=`awk '{print $1}' seed_str`
    mv ${seed}.pdb ${lig_s}.pdb submov #删除 ${seed}.pdb ${lig_s}.pdb  subcomplex

    seed=${seed}""${lig_s}
    cp -rf $seeddir"/complex.${rank}.pdb" ./${seed}.pdb #用这个作为种子 进行下一步的迭代。
done
