function fractional_trophic_level(N::T) where {T<:UnipartiteNetwork}
  Y = nodiagonal(N)
  producers = keys(filter((sp,de) -> de == 0, degree(Y,1)))
  sp = shortest_path(Y)
  prod_id = find(sum(sp,2).==0)
  tl = Dict(zip(species(Y,1), maximum(sp[:,prod_id],2).+1))
  return tl
end

function trophic_level(N::T) where {T<:UnipartiteNetwork}
  TL = fractional_trophic_level(N)
  Y = nodiagonal(N)
  D = zeros(Float64, size(Y.A))
  ko = degree_out(Y)

  # inner loop to avoid dealing with primary producers
  for i in 1:richness(Y)
    if ko[species(Y)[i]] > 0.0
      D[i,:] = Y[i,:]./ko[species(Y)[i]]
    end
  end

  # return
  return Dict(zip(species(N), 1 .+ D * [TL[s] for s in species(Y)]))
end
