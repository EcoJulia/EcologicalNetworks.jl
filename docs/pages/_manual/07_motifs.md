---
title : Motif enumeration
author : Timothée Poisot
date : 18th April 2018
layout: default
slug: motifs
---




`EcologicalNetwork` offers functions to count motifs in multiple sorts of
networks [@MilShe02]. The most important function to know about is `find_motif`,
which requires two arguments: a network, and a motif. The motif *must* be a
`BinaryNetwork`, but the network can be of any type.

Internally, the package will take the adjacency matrix of the motif, and return
all unique permutations of it. Then the code will take all combinations of
species, and induce the corresponding subgraph in the network -- if the
adjacency matrix of the induced subgraph is found in the permutations of the
motif adjacency matrix, the species combination is returned. For unipartite
networks, the package comes with a `unipartitemotifs` function, which has all
the unipartite motifs between three species as defined by @StoCam07.

## Generalities

The `find_motif` function will return an array with species that form the
given motifs. Depending on the size of the network, and the frequency of the
motif, this array can get quite big.

````julia
N = web_of_life("M_PA_003")
m = BipartiteNetwork([true true false; false true true])
motif = find_motif(N,m)
println("This motif is found $(length(motif)) times")
````


````
This motif is found 139 times
````





Because the identity of species is returned, we can extract a sub-network to
check that it is indeed in the correct conformation. Note that we use `...`
to *unpack* the species name in order to access the correct sub-network.

````julia
N[first(motif)...].A
````


````
2×3 Array{Int64,2}:
 93   0  7
  0  70  1
````





You may also notice that the network is quantitative, but the motif is not.
By default, the function *requires* motifs to be of the `BinaryNetwork` type
(and their partiteness must match the one of the network). The network in
which you want to count motifs can be either binary (no operation applied),
probabilistic (no operation applied), or quantitative (converted to binary).
Unipartite networks have their diagonal removed.

## Probabilistic networks

The `find_motif` function also works for probabilistic networks, using the logic
outlined in @PoiCir16 -- the only difference is that it will return *all*
species combinations, with an associated probability of the combination forming
the motif, and a variance. The output of this function will therefore be an
array with elements of the shape `((species,),(mean,variance))`.

````julia
U = nz_stream_foodweb()[4]
m = unipartitemotifs()[:S1]
N = null2(U)
motif = find_motif(N, m)
first(motif)
````


````
((String["Unidentified detritus", "Terrestrial Invertebrates", "Macrophyte"
],), (0.029528795926838467, 0.029306482736651363))
````





Because *all* species combinations are returned, this object *will* get big.
There is no anticipated workaround at this time.

There is a convenience function to measure the expected count of any motif
measured on a probabilistic network, and its variance:
`expected_motif_count`.

````julia
expected_motif_count(motif)
````


````
(986.1674247555279, 980.4824811808437)
````


