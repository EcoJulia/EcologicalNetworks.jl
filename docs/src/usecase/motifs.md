# Counting motifs

In this use case, we will count the number of motifs in a food web.
Specifically, we will count how many times there is a linear food chain (A→B→C)
between three species.

~~~@example
using EcologicalNetwork

# Load a network
N = stony();

# List of motifs
m = unipartitemotifs();
~~~

The `m` object has 13 different motifs, named as in [Stouffer *et al.*
(2007)][sto]. The function [`unipartitemotifs`](@ref) will generate them when
needed. Let's look at the `m[:S1]` motif:

~~~@example

plot_network(m[:S1], file="motifs1.png")

~~~

![motif s1][ms1]

[ms1]: motifs1.png

[sto]: http://rspb.royalsocietypublishing.org/content/274/1621/1931

The function to count motifs is called [`motif`](@ref), and returns a count: how
many triplets of species are in a given conformation. For example:

~~~@example
s1 = motif(N, m[:S1])
~~~

We may be interested in knowing whether this motif is over or under-represented
in the empirical network, compared to a random expectation. To determine this,
we will shuffle interactions around in a way that preserves the distribution of
degrees, using [`swaps`](@ref). We will create 100 replicated networks to test.

~~~@example
permutations = swaps(N, 100, constraint=:degree)
ms1 = map(x -> motif(x, m[:S1]), permutations)
~~~
