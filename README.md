# MERFISHer

## What is MERFISHer?

MERFISH is a Spatial Single Cell Transcriptome capturing technology<sup>[1](https://www.pnas.org/content/113/50/14456)</sup>. It not only generates the single cell transcriptome like other single cell technology (not exactly but anyway), but also generates the locations of every cell and every transcript. The figure below, which shows the results from the MERFISH dataset, is from the analysis results of one of the dataset publically available online<sup>[2](https://zenodo.org/record/5512749#.Yd2eHdHMKUk)</sup>.

![alt text](https://github.com/Zha0rong/MERFISHer/blob/main/pics/Plot%20Cell%20by%20real%20probes-1.png "MERFish figure 1")

This dataset is generated from a piece of Mouse Ileum. Just by looking at the figure above you will notice that in different places of the tissue the cellular compositions are different. MERFISHer is an un-biased clustering approach to 'fish out' regions with different cellular composition which may potentially be biologically meaningful.

## Method

MERFISHer first breaks the whole image into small equalize size fragments. Then the cell composition of each fragment is calculated.

The fragments are clustered using the Louvain Community Detection Algorithm<sup>[3](https://iopscience.iop.org/article/10.1088/1742-5468/2008/10/P10008/meta)</sup>.

And the results of clustering are shown in the html file in the Repository and the figure below.

![alt text](https://github.com/Zha0rong/MERFISHer/blob/main/pics/Visualization%20of%20Clustering%20Results-1.png "MERFish figure 2")


## Citation
[1] Moffitt, J. R., Hao, J., Bambah-Mukku, D., Lu, T., Dulac, C., & Zhuang, X. (2016). High-performance multiplexed fluorescence in situ hybridization in culture and tissue with matrix imprinting and clearing. Proceedings of the National Academy of Sciences, 113(50), 14456-14461.

[2] Moffitt, Jeffrey, Xu, Rosalind, Kharchenko, Peter, Petukhov, Viktor, Cadinu, Paolo, Soldatov, Ruslan, & Khodosevich, Konstantin. (2021). MERFISH measurements in the mouse ileum [Data set]. https://doi.org/10.5061/dryad.jm63xsjb2

[3] Blondel, V. D., Guillaume, J. L., Lambiotte, R., & Lefebvre, E. (2008). Fast unfolding of communities in large networks. Journal of statistical mechanics: theory and experiment, 2008(10), P10008.
