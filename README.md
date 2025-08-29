# SynergisticMotifsGaussianSystems
The repository accompanies the paper: "Synergistic Motif in Gaussian Systems".
It includes all the notebooks used to collect data and plot the figures in the paper and in the supplementary material.

md"""
# Overview

These [Pluto notebooks](https://plutojl.org/) should be mostly plug and play.
The main thing you have to do is to load some data for the non-isomporhic graphs, update the relevant paths, and install the python package `HOI` (see below).

If you want to just have a quick look and run some simulations, I added in each notebook a cell containing some non-isomorphic graphs. For graphs of size N > 5 you will need to store these somewhere else.

All the figures use data that can be generated here in just a few seconds or worst a few minutes (except the SL simulation for N=6). To reproduce exactly what is shown in the paper, use the same seeds to generate the random numbers used here (these should always be sepcified otherwise reach out).

---

### Non-isomorphic graphs data
To visualize and use the non-isomporhic graphs, you should download the dataset from `https://users.cecs.anu.edu.au/~bdm/data/graphs.html`, curated by Brendan McKay.

**Note:** you will need to convert the `graph6` format to something readable. You can follow the instructions from `https://users.cecs.anu.edu.au/~bdm/data/formats.html` to do this.

In the notebooks, the function used to load the graphs data only works **after** you have converted it to `.txt`. You can find an example of what the raw `.txt` file should look like in the folder "". If you are using a different dataset you should modify it accordingly.

**Note:** in what follows the `matrix index` often abbreviated as `id` specifies the interaction matrix used. If you use a different dataset of non-isomorphic graphs the indeces may be different.

### Installing python packages in Julia
To check our results and estimate entropies using Gaussian copula (only used for SL) we use the python package `HOI`. This is not too bad to do in Julia, I found `CondaPkg.jl` to work pretty well (`Conda.jl` gave me some issues instead when force to install using pip).

```
CondaPkg.add_pip("hoi")
CondaPkg.add("numpy")
CondaPkg.status()
```

For the empirical data analysis, we used python. The final figure was then plotted in Julia.
"""
