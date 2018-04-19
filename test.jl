include("src/EcologicalNetwork.jl")
using EcologicalNetwork
using Combinatorics

function permute_motif{T<:AbstractUnipartiteNetwork}(m::T)
    perm = []
    for s in permutations(species(m))
        push!(perm, m[s].A)
    end
    unique_perm = unique(perm)
    return unique_perm
end

function enumerate_motifs{T1<:UnipartiteNetwork,T2<:UnipartiteNetwork}(N::T1, m::T2)
    motif_permutations = permute_motif(m)
    matching_species = []
    for species_combination in combinations(species(N), richness(m))
        if N[species_combination].A ∈ motif_permutations
            push!(matching_species, (species_combination,))
        end
    end
    return matching_species
end

function permute_motif{T<:AbstractBipartiteNetwork}(m::T)
    perm = []
    for ts in permutations(species(m,1)), bs in permutations(species(m,2))
        push!(perm, m[ts,bs].A)
    end
    unique_perm = unique(perm)
    return unique_perm
end

function enumerate_motifs{T1<:BipartiteNetwork,T2<:BipartiteNetwork}(N::T1, m::T2)
    motif_permutations = permute_motif(m)
    matching_species = []
    top_combinations = combinations(species(N,1), richness(m,1))
    bottom_combinations = combinations(species(N,2), richness(m,2))
    for top_species in top_combinations, bottom_species in bottom_combinations
        if N[top_species, bottom_species].A ∈ motif_permutations
            push!(matching_species, (top_species, bottom_species))
        end
    end
    return matching_species
end

function enumerate_motifs{T1<:UnipartiteProbabilisticNetwork, T2<:UnipartiteNetwork}(N::T1, m::T2)
    motif_permutations = permute_motif(m)
    all_combinations = []
    for species_combination in combinations(species(N), richness(m))
        isg = N[species_combination]
        motif_mean, motif_var = 0.0, 0.0
        for perm in motif_permutations
            imat = zeros(eltype(N.A), size(m))
            for i in eachindex(imat)
                imat[i] = (perm[i]?2.0*isg[i]:1.0)-isg[i]
            end
            pmm, pmv = prod(imat), EcologicalNetwork.m_var(imat)
            motif_mean += pmm
            motif_var += pmv
        end
        push!(all_combinations, ((species_combination,),(motif_mean, motif_var)))
    end
    return all_combinations
end

function enumerate_motifs{T1<:BipartiteProbabilisticNetwork, T2<:BipartiteNetwork}(N::T1, m::T2)
    motif_permutations = permute_motif(m)
    all_combinations = []
    top_combinations = combinations(species(N,1), richness(m,1))
    bottom_combinations = combinations(species(N,2), richness(m,2))
    for top_species in top_combinations, bottom_species in bottom_combinations
        isg = N[top_species, bottom_species]
        motif_mean, motif_var = 0.0, 0.0
        for perm in motif_permutations
            imat = zeros(eltype(N.A), size(m))
            for i in eachindex(imat)
                imat[i] = (perm[i]?2.0*isg[i]:1.0)-isg[i]
            end
            pmm, pmv = prod(imat), EcologicalNetwork.m_var(imat)
            motif_mean += pmm
            motif_var += pmv
        end
        push!(all_combinations, ((top_species, bottom_species),(motif_mean, motif_var)))
    end
    return all_combinations
end
