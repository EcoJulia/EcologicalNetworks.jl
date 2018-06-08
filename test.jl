using Revise # To avoid reloading the session while we test things
include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using StatsBase
using NamedTuples
using Combinatorics
using Base.Test

N = convert(BinaryNetwork, web_of_life("A_HP_001"))
m_null = BipartiteNetwork([false false; false false])
m_sing = BipartiteNetwork([true false; false false])
m_appa = BipartiteNetwork([false false; true true])
m_dire = BipartiteNetwork([true false; true false])
m_zeta = BipartiteNetwork([true false; true true])
m_bicl = BipartiteNetwork([true true; true true])

f(n,m) = length(find_motif(n,m))

a = BipartiteNetwork(rand(Bool, (50,60)))
Profile.clear()
@time f(a, m_null)
@profile f(a, m_null)
Juno.profiler()


N = nz_stream_foodweb()[1]
Profile.clear()
@time graph_layout(N, steps=300)
@time graph_layout(N, steps=300)
@profile graph_layout(N, steps=300)
Juno.profiler()
