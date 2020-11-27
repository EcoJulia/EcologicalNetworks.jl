function UnipartiteQuantitativeNetwork(A::Matrix{IT}) where {IT<:Number}
  check_unipartiteness(A)
  S = "s".*string.(1:size(A,1))
  UnipartiteQuantitativeNetwork{IT,eltype(S)}(A, S)
end

function UnipartiteQuantitativeNetwork(A::Matrix{IT}, S::Vector{NT}) where {IT<:Number,NT}
  check_species_validity(NT)
  check_unipartiteness(A, S)
  UnipartiteQuantitativeNetwork{IT,NT}(A, S)
end

function UnipartiteProbabilisticNetwork(A::Matrix{IT}) where {IT<:AbstractFloat}
  check_unipartiteness(A)
  check_probability_values(A)
  S = "s".*string.(1:size(A,1))
  UnipartiteProbabilisticNetwork{IT,eltype(S)}(A, S)
end

function UnipartiteProbabilisticNetwork(A::Matrix{IT}, S::Vector{NT}) where {IT<:AbstractFloat,NT}
  check_species_validity(NT)
  check_unipartiteness(A, S)
  check_probability_values(A)
  UnipartiteProbabilisticNetwork{IT,NT}(A, S)
end
