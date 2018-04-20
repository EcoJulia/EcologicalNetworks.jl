#' ---
#' title : Motif enumeration
#' author : Timothée Poisot
#' date : 18th April 2018
#' layout: default
#' ---

#+ echo=false; results="hidden"
using EcologicalNetwork
using Base.Test

#' `EcologicalNetwork` offers functions to count motifs in multiple sorts of
#' networks. The most important function to know about is `find_motif`, which
#' requires two arguments: a network, and a motif.

#' **TODO** explain how it works

#' ## Generalities

#' The `find_motif` function will return an array with species that form the
#' given motifs. Depending on the size of the network, and the frequency of the
#' motif, this array can get quite big.

N = fonseca_ganade_1996()
m = BipartiteNetwork([true true false; false true true])
motif = find_motif(N,m)
println("This motif is found $(length(motif)) times")

#' Because the identity of species is returned, we can extract a sub-network to
#' check that it is indeed in the correct conformation. Note that we use `...`
#' to *unpack* the species name in order to access the correct sub-network.

N[first(motif)...].A

#' You may also notice that the network is quantitative, but the motif is not.
#' By default, the function *requires* motifs to be of the `BinaryNetwork` type
#' (and their partiteness must match the one of the network). The network in
#' which you want to count motifs can be either binary (no operation applied),
#' probabilistic (no operation applied), or quantitative (converted to binary).
#' Unipartite networks have their diagonal removed.

#' ## Probabilistic networks

#' The `find_motif` function also works for probabilistic networks -- the only
#' difference is that it will return *all* species combinations, with an
#' associated probability of the combination forming the motif, and a variance.
#' The output of this function will therefore be an array with elements of the
#' shape `((species,),(mean,variance))`.

U = thompson_townsend_catlins()
m = unipartitemotifs()[:S1]
N = null2(U)
motif = find_motif(N, m)
first(motif)

#' Because *all* species combinations are returned, this object *will* get big.
#' There is no anticipated workaround at this time.

#' There is a convenience function to measure the expected count of any motif
#' measured on a probabilistic network, and its variance:
#' `expected_motif_count`.

expected_motif_count(motif)