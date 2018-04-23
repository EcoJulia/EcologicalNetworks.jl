---
title : Drawing networks
author : Timothée Poisot
date : 11th April 2018
layout: default
---




The network representations have been taken from @McG12. They are not meant to
offer a full network visualisation suite, but they allow to create pictures to
explore network structure. All data visualisation relies on the `Luxor` package --
this means that networks can be produced as `.png`, `.svg`, and `.pdf` files.

All layouts have a number of common options, passed as *keyword* arguments:

1. `filename` -- the name/path of the figure (defaults to `network.png`)
2. `fontname` -- the name of the font for labels (defaults to `Noto Sans Condensed`)
3. `fontsize` -- the size of the font for labels (defaults to `16`)
4. `steps` -- the number of layout positioning steps to do (defaults to `500`)

Additionaly, all functions share similarities in their output. In bipartite
networks, nodes from the top level are orange, and the bottom level nodes are
blue. In unipartite networks, all nodes are green. The colors come from @Won11 --
and have been picked to ensure maximum disimilarity under normal vision,
deuteranopia, tritanopia, and protanopia.

This page will illustrate the currently implemented layouts using a bipartite
and a unipartite network:

````julia
N = fonseca_ganade_1996()
U = thompson_townsend_catlins()
````





## Circular layout

````julia
circular_network_plot(N; filename=joinpath(working_path, "circular_fg96.png"));
````





![Circular layout](/figures/circular_fg96.png)

````julia
circular_network_plot(U; filename=joinpath(working_path, "circular_ttc.png"));
````





![Circular layout](/figures/circular_ttc.png)
