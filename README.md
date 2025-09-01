MuMD: Multilevel Merge Dock for Protein Complex Assembly

MuMD is a computational framework designed to predict the assembly process and structure of heteromultimeric protein complexes. Unlike traditional methods that exhaustively sample conformations (NP-hard problem), MuMD employs a competition-based hierarchical strategy to simulate realistic assembly dynamics. Key features:

Efficiency: Uses ZDOCK scoring and roulette-wheel selection to prioritize high-quality subcomplexes, reducing computational costs.
Dynamic Pathway Prediction: Captures assembly order and intermediate steps, especially effective for complexes with <6 chains.
Multi-level Merging: Simulates competitive binding by iteratively docking pairs (single chains or subcomplexes) while preserving near-native conformations.
Tested on 23 complexes, MuMD achieved accurate structure and pathway predictions (e.g., Ribonucleotide reductase, TRAIL-SDR5). Ideal for studying protein interactions where temporal assembly matters.

脚本运行前 请根据自己的情况设置好脚本中的路径变量

首先准备测试数据，   详细请参考脚本 prepare_data.sh

然后针对上面准备好的数据进行组装，  详细请参考脚本  dock_complex_merge.sh

如果针对一个体系要重复运行多次，请参考脚本  dock_complex_merge_N.sh



MuMD Script Usage Guide  
 
This guide explains how to run MuMD for protein complex assembly prediction using the provided scripts. Follow these steps to prepare data, run assembly, and perform repeated simulations.  
 
---  
 
1. Prepare Test Data  
Script: `prepare_data.sh`  
Purpose: Generates input files for MuMD (e.g., PDBs of individual subunits).  
Steps:  
- Edit the script to set input/output paths and target complex PDB IDs.  
   
  more ./prepare_data.sh

  run this Script  step by step
Output: Processed subunit files in the specified directory.  
 
---  
 
2. Run Assembly Prediction  
Script: `dock_complex_merge.sh`  
Purpose: Predicts the assembly pathway and structure for a single complex.  
Steps:  
- Execute:  
  ```bash
  sh ${MYDIR}/dock_complex_merge.sh ABC N 
  ```  
Output:  
- Final assembled structure (PDB).  
- Assembly pathway.  
 
---  
 
3. Repeat Simulations (Optional)  
Script: `dock_complex_merge_N.sh`  
Purpose: Runs multiple independent assembly trials (e.g., for statistical analysis).  
Steps:  
- Set number of repeats (N) and output subdirectories.  
- Run:  
  ```bash 
  sh ${MYDIR}/dock_complex_merge_N.sh pdb_dir ABC  N  # Runs N trials 
  ```  
Output:  
- Multiple PDBs and pathways for convergence assessment.  
 
---  
 
Key Notes  
- Paths: Always update paths to ZDOCK, input files, and outputs.  
- Parameters: Tweak `topN` and decoy numbers in scripts for speed/accuracy trade-offs.  
- Visualization: Use tools like PyMOL to compare predicted vs. experimental structures.  
 

 
 

