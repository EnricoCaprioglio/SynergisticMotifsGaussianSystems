# SynergisticMotifsGaussianSystems
The repository accompanies the paper: "Synergistic Motif in Gaussian Systems".
It includes all the notebooks used to collect data and plot the figures in the paper and in the supplementary material.

The [Pluto notebooks](https://plutojl.org/) can be opened on any web browser and ran using binder. Simply download the (Julia) `html` files.

# Overview

These Pluto notebooks should be mostly plug and play.
The main thing you have to do is to load some data for the non-isomporhic graphs, update the relevant paths, and install the python package `HOI` (see below).

If you want to just have a quick look and run some simulations without loading the graphs dataset, each notebook has a cell containing some non-isomorphic graphs. For graphs of size N > 5 you will need to download the dataset.

All the figures use data that can be generated in just a few seconds or worst a few minutes (except the SL simulation for N=6). To reproduce exactly what is shown in the paper, use the same seeds to generate the random numbers used here (these should always be specified otherwise, please, reach out).

---

### Non-isomorphic graphs data
To visualize and use the non-isomporhic graphs, you should download the openly available dataset from `https://users.cecs.anu.edu.au/~bdm/data/graphs.html`, curated by Brendan McKay.

**Note:** you will need to convert the `graph6` format to something readable. You can follow the instructions from `https://users.cecs.anu.edu.au/~bdm/data/formats.html` to do this.

In the notebooks, the function used to load the graphs data only works **after** you have converted the graphs and stored the data in a `.txt` file. You can find an example of what the raw `.txt` file should look like in the repository. If you are using a different dataset you should modify it accordingly.

**Note:** in what follows the `matrix index` often abbreviated as `id` specifies the interaction matrix used. If you use a different dataset of non-isomorphic graphs the indeces may be different.

### Installing python packages in Julia
To check our results and estimate entropies using Gaussian copula (only used for SL experiment) we use the python package `HOI`. You can find more details [here](https://brainets.github.io/hoi/index.html). This is not too bad to do in Julia. We used the package `CondaPkg.jl` to install `HOI` and use it directly in the Pluto notebooks:

```
CondaPkg.add_pip("hoi")
CondaPkg.add("numpy")
CondaPkg.status()
```

For the empirical data analysis, we used python and the python package `THOI`, see [here](https://github.com/Laouen/THOI) and accompanying paper ["THOI: An efficient and accessible library for computing higher-order interactions enhanced by batch-processing"](https://arxiv.org/abs/2501.03381v1) for more info. The final figure (Fig. 4 in the main text) was then plotted in Julia.

## Contact Details

Any questions, do not hesitate to contact me:

**Author:** Enrico Caprioglio

**Email:** ec627@sussex.ac.uk
