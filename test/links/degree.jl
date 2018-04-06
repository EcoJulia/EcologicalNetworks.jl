module TestDegreeFunctions
  using Base.Test
  using EcologicalNetwork

  # Generate some data

  N = UnipartiteProbabilisticNetwork([0.22 0.4; 0.3 0.1], [:a, :b])

  d_in = vec([0.52 0.5])
  d_out = vec([0.62 0.4])
  d_tot = vec([1.14 0.9])

  Din = degree_in(N)
  Dout = degree_out(N)
  Dtot = degree(N)

  Dov = degree_out_var(N)
  @test Dov[:b] ≈ 0.3

  Div = degree_in_var(N)
  @test Div[:a] ≈ 0.3816

  Dv = degree_var(N)
  @test Dv[:b] ≈ 0.63

  for i in eachindex(species(N))
    @test d_in[i] ≈ Din[species(N)[i]]
    @test d_out[i] ≈ Dout[species(N)[i]]
    @test d_tot[i] ≈ Dtot[species(N)[i]]
  end

end
