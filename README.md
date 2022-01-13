# Buzz

## What is Buzz?

Buzz is a pipeline that can be used to find different regions of biological interest by cellular composition in Spatial Transcriptome dataset.

For now it only supports MERFISH. The support for Visium is coming soon.

## What is MERFISH?

MERFISH is a Spatial Single Cell Transcriptome capturing technology<sup>[1](https://www.pnas.org/content/113/50/14456)</sup>. It not only generates the single cell transcriptome like other single cell technology (not exactly but anyway), but also generates the locations of every cell and every transcript. The figure below, which shows the results from the MERFISH dataset, is from the analysis results of one of the dataset publically available online<sup>[2](https://zenodo.org/record/5512749#.Yd2eHdHMKUk)</sup>.

![alt text](https://github.com/Zha0rong/MERFISHer/blob/main/pics/Plot%20Cell%20by%20real%20probes-1.png "MERFish figure 1")

This dataset is generated from a piece of Mouse Ileum. Just by looking at the figure above you will notice that in different places of the tissue the cellular compositions are different. MERFISHer is an un-biased clustering approach to 'fish out' regions with different cellular composition which may potentially be biologically meaningful.

## Method

Buzz first breaks the whole image into small equalize size fragments. Then the cell composition of each fragment is calculated.

The fragments are clustered using the Louvain Community Detection Algorithm<sup>[3](https://iopscience.iop.org/article/10.1088/1742-5468/2008/10/P10008/meta)</sup>.

The full results of clustering are shown in the html file in the Repository. The figure below shows that the algorithm can adequately capture the differences in cell compositions in different regions of the tissue.

![alt text](https://github.com/Zha0rong/Buzz/blob/main/pics/Visualization%20of%20Clustering%20Results-1.png "MERFish figure 2")

## How to use it.

### What is already here.

For now only output from Baysor<sup>[4](https://github.com/kharchenkolab/Baysor)</sup> are accepted.
User needs to provide:
  1. files from Baysor output (all gzipped):
   
   segmentation.csv.gz
   
   segmentation_cell_stats.csv.gz
   
   segmentation_counts.tsv.gz
   
  2. one comma-delimited file named as 'cell_assignment.csv.gz'. The file should only contain two columns: the first one is the cell name (in agreement with the cell name from Baysor) and the second column is the cell identity assigned to each cell (it does not have to be cell types, it can be clusters).

### What is yet to be.

Generalize the pipeline to fit other types of output (such as cellpose<sup>[5](https://www.nature.com/articles/s41592-020-01018-x)</sup>).

Make a package out of it for better user experience.



## Citation
[1] Moffitt, J. R., Hao, J., Bambah-Mukku, D., Lu, T., Dulac, C., & Zhuang, X. (2016). High-performance multiplexed fluorescence in situ hybridization in culture and tissue with matrix imprinting and clearing. Proceedings of the National Academy of Sciences, 113(50), 14456-14461.

[2] Moffitt, Jeffrey, Xu, Rosalind, Kharchenko, Peter, Petukhov, Viktor, Cadinu, Paolo, Soldatov, Ruslan, & Khodosevich, Konstantin. (2021). MERFISH measurements in the mouse ileum [Data set]. https://doi.org/10.5061/dryad.jm63xsjb2

[3] Blondel, V. D., Guillaume, J. L., Lambiotte, R., & Lefebvre, E. (2008). Fast unfolding of communities in large networks. Journal of statistical mechanics: theory and experiment, 2008(10), P10008.

[4] Petukhov V, Xu RJ, Soldatov RA, Cadinu P, Khodosevich K, Moffitt JR & Kharchenko PV. Cell segmentation in imaging-based spatial transcriptomics. Nat Biotechnol (2021). https://doi.org/10.1038/s41587-021-01044-w

[5] Stringer, C., Wang, T., Michaelos, M., & Pachitariu, M. (2021). Cellpose: a generalist algorithm for cellular segmentation. Nature Methods, 18(1), 100-106.
