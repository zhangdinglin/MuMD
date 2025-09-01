#zdl
cat tmp_f1 >pair_score_all;echo "next step" >>pair_score_all;cat tmp_f_all >>pair_score_all;
cat seed_str1 >conform_all;cat seed_str_all >>conform_all;
sed -i '/^$/d' pair_score_all conform_all

#get pair for each step
awk 'BEGIN{big_sc=-1000000}{
	if($1=="next")
        {
	    if(big_sc != -1000000)
            {
		#printf("%s %s\n", pair,big_sc)
		printf("%s\n", pair)
            	big_sc=-1000000
	    }
        }
	else if(substr($1,1,5)=="zdock")
	{
		if(big_sc<$NF){big_sc=$NF;pair=$1}
	}

}' ./pair_score_all >pair_choose_all


#get conformation for each step
awk '{
        if($1 != "next")
        {
            printf("%s\n",$0) 

        }

}' ./conform_all >conform_choose_all
paste  pair_choose_all conform_choose_all >pair_conf_choose_all



cat pair_conf_choose_all |while read f
do 
	#echo $f; 
	#array=(${f//,/ });
        
        pair=`echo $f|awk '{print $1}'`
        confn=`echo $f|awk '{print $2}'`
	#echo  array[0],array[1];

        ((line_n=confn+5))
        #echo  $confn $line_n
	echo -n "$f  "
        sed -n "${line_n}p" ${pair}/zdock.out|awk '{print $NF}'
done >sc_total_tmp
awk '{sc_total=sc_total+$3}END{print sc_total}' sc_total_tmp >sc_total
