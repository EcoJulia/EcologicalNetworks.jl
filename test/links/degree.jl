module TestDegreeFunctions
  using Base.Test
  using EcologicalNetwork

  # Generate some data

  N = UnipartiteProbabilisticNetwork([0.22 0.4; 0.3 0.1], [:a, :b])

  d_in = vec([0.52 0.5])
  d_out = vec([0.62 0.4])
  d_tot = vec([1.14 0.9])

  Q = BipartiteQuantitativeNetwork(rand(Float64, (3, 5)))
  D = convert(BinaryNetwork, Q)
  @test degree(Q) == degree(D)
  @test degree(Q,1) == degree(D,1)
  @test degree(Q,2) == degree(D,2)

  Dov = degree_var(N, 1)
  @test Dov[:b] ≈ 0.3

  Dv = degree_var(N, 2)
  @test Dv[:b] ≈ 0.33

  @test_throws ArgumentError degree(N, 3)
  @test_throws ArgumentError degree(N, 0)

  # Variance

  N = UnipartiteProbabilisticNetwork([0.22 0.4; 0.3 0.1])

  Din = degree(N, 2)
  Dout = degree(N, 1)
  Dtot = degree(N)

  Dov = degree_var(N, 1)
  @test Dov["s2"] ≈ 0.3 atol=0.001
  @test Dov["s1"] ≈ 0.41159 atol=0.001

  Div = degree_var(N, 2)
  @test Div["s1"] ≈ 0.3816 atol=0.01

  Dv = degree_var(N)
  @test Dv["s2"] ≈ 0.63 atol=0.001

end
