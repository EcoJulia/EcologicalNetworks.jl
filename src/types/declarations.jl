import Base: eltype

"""
This is an abstract type that allows to generate functions for all sorts of
networks. All other types are derived from this one.
"""
abstract type AbstractEcologicalNetwork end

"""
All unipartite networks
"""
abstract type AbstractUnipartiteNetwork <: AbstractEcologicalNetwork end

"""
All bipartite networks
"""
abstract type AbstractBipartiteNetwork <: AbstractEcologicalNetwork end

"""
The species names can be strings or symbols -- for now.
"""
AllowedSpeciesTypes = Union{String,Symbol}

"""
A bipartite deterministic network is a two-dimensional array of boolean values.
"""
struct BipartiteNetwork{T<:AllowedSpeciesTypes} <: AbstractBipartiteNetwork
  A::Matrix{Bool}
  T::Vector{T}
  B::Vector{T}
  function BipartiteNetwork{NT}(A::M, T::Vector{NT}, B::Vector{NT}) where {M<:AbstractMatrix{Bool}, NT<:AllowedSpeciesTypes}
    check_bipartiteness(A, T, B)
    new{NT}(A, T, B)
  end
end

"""
An unipartite deterministic network.
"""
struct UnipartiteNetwork{T<:AllowedSpeciesTypes} <: AbstractUnipartiteNetwork
  A::Matrix{Bool}
  S::Vector{T}
  function UnipartiteNetwork{NT}(A::M, S::Vector{NT}) where {M<:AbstractMatrix{Bool}, NT<:AllowedSpeciesTypes}
    check_unipartiteness(A, S)
    new{NT}(A, S)
  end
end

"""
TODO
"""
struct BipartiteProbabilisticNetwork{IT<:AbstractFloat, NT<:AllowedSpeciesTypes} <: AbstractBipartiteNetwork
  A::Array{IT,2}
  T::Array{NT,1}
  B::Array{NT,1}
end

"""
TODO
"""
struct BipartiteQuantitativeNetwork{IT<:Number, NT<:AllowedSpeciesTypes} <: AbstractBipartiteNetwork
  A::Array{IT,2}
  T::Array{NT,1}
  B::Array{NT,1}
end

"""
TODO
"""
struct UnipartiteProbabilisticNetwork{IT<:AbstractFloat, NT<:AllowedSpeciesTypes} <: AbstractUnipartiteNetwork
  A::Array{IT,2}
  S::Array{NT,1}
end

"""
TODO
"""
struct UnipartiteQuantitativeNetwork{IT<:Number, NT<:AllowedSpeciesTypes} <: AbstractUnipartiteNetwork
  A::Array{IT,2}
  S::Array{NT,1}
end

"""
This is a union type for both Bipartite and Unipartite probabilistic networks.
Probabilistic networks are represented as arrays of floating point values ∈
[0;1].
"""
ProbabilisticNetwork = Union{BipartiteProbabilisticNetwork, UnipartiteProbabilisticNetwork}

"""
This is a union type for both Bipartite and Unipartite deterministic networks.
All networks from these class have adjacency matrices represented as arrays of
Boolean values.
"""
BinaryNetwork = Union{BipartiteNetwork, UnipartiteNetwork}

"""
This is a union type for both unipartite and bipartite quantitative networks.
All networks of this type have adjancency matrices as two-dimensional arrays of
numbers.
"""
QuantitativeNetwork = Union{BipartiteQuantitativeNetwork, UnipartiteQuantitativeNetwork}

"""
All non-probabilistic networks
"""
DeterministicNetwork = Union{BinaryNetwork, QuantitativeNetwork}

"""
    eltype(N::T) where T<:AbstractEcologicalNetwork

Returns a tuple with two types: the type of the interactions, and the type of
the species objects.
"""
function eltype(N::T) where T<:AbstractEcologicalNetwork
    return (eltype(N.A),eltype(species(N)))
end
