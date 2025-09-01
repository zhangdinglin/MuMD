rm -rf receptor_m.pdb ligand_m.pdb
./mark_sur receptor.pdb receptor_m.pdb
./mark_sur ligand.pdb ligand_m.pdb
./zdock -R receptor_m.pdb -L ligand_m.pdb -o zdock.out
./create.pl zdock.out

