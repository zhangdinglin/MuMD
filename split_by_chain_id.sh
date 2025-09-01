#param1  pdbfile
#call method ~/zdl_bin/split_by_chain_id.sh BPG.pdb 
#awk -v chain="$2" 'BEGIN{}
awk  'BEGIN{}
{

	if(($1=="ATOM"||substr($1,1,6)=="HETATM") && NF>=8)
        {
	
		if($1=="ATOM"||substr($1,1,6)=="HETATM")
		{
#			print substr($1,1,4)
                        print $0 > substr($0,22,1)".pdb"
			#printf("%s%s%s\n", substr($0,0,21),chain,substr($0,23,100))
		}
	}
	else
	{ print $0}

}' $1
