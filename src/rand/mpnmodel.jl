"""

    mpnmodel(spec::Int64, Co::Float64, forbidden::Float64)

Return `UnipartiteNetwork` with links assigned according to minimum
potential niche model for given number of `spec`, connectivity `Co` and
probability of `forbidden` link occurence.

> Allesina, S., Alonso, D. and Pascual, M. (2008) ‘A General Model for Food Web
> Structure’, Science, 320(5876), pp. 658–661. doi: 10.1126/science.1156269.

# Examples
```jldoctest
julia> A = mpnmodel(25, 0.45, 0.5)
```

See also: `nichemodel`, `cascademodel`, `nestedhierarchymodel`

"""
function mpnmodel(spec::Int64, Co::Float64, forbidden::Float64)

    Co >= 0.5 && throw(ArgumentError("The connectance cannot be larger than 0.5"))

    # Beta distribution parameter
    β = 1.0/(2.0*Co)-1.0

    # Pre-allocate the network
    A = UnipartiteNetwork(zeros(Bool, (spec, spec)))

    # Generate body size
    n = sort(rand(Uniform(0.0, 1.0), spec))

    # Pre-allocate centroids
    c = zeros(Float64, spec)

    # Generate random ranges
    r = n .* rand(Beta(1.0, β), spec)

    # Generate random centroids
    for s in 1:spec
        c[s] = rand(Uniform(r[s]/2, n[s]))
    end

    # The smallest species has a body size and range of 0
    for small_species_index in findall(x -> x == minimum(n), n)
        n[small_species_index] = 0.0
        r[small_species_index] = 0.0
    end

    # Testing
    # -------------------------------------------------------------------------
    # ranges = Dict{Int64, Tuple}()
    # -------------------------------------------------------------------------

    for consumer in 1:spec

        # For testing
        # ---------------------------------------------------------------------
        # u = c[consumer] + r[consumer]
        # l = c[consumer] - r[consumer]
        # diet = findall(x -> (x > l) & (x < u), n)
        # #println("Species ", diet, " fall into diet of consumer ", consumer)
        # length(diet) != 0 && (ranges[consumer] = (diet[1], diet[end]))
        # ---------------------------------------------------------------------

        for resource in 2:(spec-1)

            lower = (n[resource] > (c[consumer] - r[consumer]))
            lowerminus = (n[resource-1] > (c[consumer] - r[consumer]))
            upper = n[resource] < (c[consumer] + r[consumer])
            upperplus = n[resource+1] < (c[consumer] + r[consumer])

            if (upper & lower)

                (rand() < (1 - forbidden)) && (A[consumer, resource] = true)

                # Take care of first and last resource if they belong to the range
                ((resource-1 == 1) & lowerminus) && (A[consumer, resource-1] = true)
                ((resource+1 == spec) & upperplus) && (A[consumer, resource+1] = true)

                # Edges of range
                lowerminus || (A[consumer, resource] = true)
                upperplus || (A[consumer, resource] = true)


            end

        end

    end

    return A

end

"""

    mpnmodel(N::T) where {T<: UnipartiteNetwork}

Applied to `UnipartiteNetwork` return its randomized version.

# Examples
```jldoctest
julia> empirical_foodweb = EcologicalNetworks.nz_stream_foodweb()[1]
julia> A = mpnmodel(empirical_foodweb)
```

"""
function mpnmodel(N::T) where {T<: UnipartiteNetwork}

    # Estimate proportion of forbidden links

    ## Find ordering
    ## sort(N)

    ## Get the value
    forbidden = 0

    # Simulate the network
    return mpn(species(N), connectance(N), forbidden)

end

"""

    mpnmodel(parameters::Tuple)

Parameters tuple can also be provided in the form (spec::Int64, Co::Float64,
forbidden::Float64).

"""
function mpnmodel(parameters::Tuple)
    return mpnmodel(parameters[1], parameters[2],parameters[3])
end
