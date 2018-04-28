function foodweb_layout(N; steps=15000, L=50.0, R=0.05)

    tl = fractional_trophic_level(N)

    nodes = Dict([species(N)[i] => Dict(:x => rand()-0.5, :y => tl[species(N)[i]], :fx => 0.0, :fy => 0.0, :n => eltype(species(N))[]) for i in 1:richness(N)])
    for s in species(N)
        neighbors = eltype(species(N))[]
        if s in species(N,2)
            for s2 in species(N,1)
                if has_interaction(N, s2, s)
                    push!(neighbors, s2)
                end
            end
        end
        if s in species(N,1)
            for s2 in species(N,2)
                if has_interaction(N, s, s2)
                    push!(neighbors, s2)
                end
            end
        end
        neighbors = filter(x -> x!=s, neighbors)
        nodes[s][:n] = neighbors
    end
    return foodweb_layout(N, nodes, steps=steps, L=L, R=R)
end

function foodweb_layout(N, nodes; steps=15000, L=50.0, R=0.05)

    Δt = 0.01
    Kr = 6250.0
    Ks = Kr/(R*L^3)
    max_squared_displacement = Δt*5.5

    for step in 1:steps
        # Repulsion between all pairs
        for s1_i in eachindex(species(N)[1:(end-1)])
            for s2_i in (s1_i+1):richness(N)
                s1, s2 = species(N)[[s1_i,s2_i]]
                if nodes[s1][:y] == nodes[s2][:y]
                    dx = nodes[s1][:x] - nodes[s2][:x]
                    if (dx != 0.0)
                        squared_distance = dx*dx
                        distance = sqrt(squared_distance)
                        force = Kr/squared_distance
                        fx = force * dx / distance
                        nodes[s1][:fx] += fx
                        nodes[s2][:fx] -= fx
                    end
                end
            end
        end
        # Attraction between connected pairs
        for s1 in species(N)
            if length(nodes[s1][:n]) > 0
                for s2 in nodes[s1][:n]
                    spos = first(find(species(N).==s1))
                    s2pos = first(find(species(N).==s2))
                    if spos < s2pos
                        dx = nodes[s1][:x] - nodes[s2][:x]
                        if (dx != 0.0)
                            distance = sqrt(dx*dx)
                            force = Ks * (distance - L)
                            fx = force * dx / distance
                            nodes[s1][:fx] -= fx
                            nodes[s2][:fx] += fx
                        end
                    end
                end
            end
        end
        # Attraction to the center
        for s1 in species(N)
            dx = nodes[s1][:x] - 0.0
            if (dx != 0.0)
                distance = sqrt(dx*dx)
                force = Ks * (distance - L) * 0.1
                fx = force * dx / distance
                nodes[s1][:fx] -= fx
            end
        end
        # Movement
        for s in species(N)
            dx = Δt * nodes[s][:fx]
            squared_displacement = dx*dx
            if squared_displacement > max_squared_displacement
                sc = sqrt(max_squared_displacement / squared_displacement)
                dx *= sc
            end
            nodes[s][:x] += dx
            nodes[s][:fx] = 0.0
        end
    end
    return (N, nodes)
end
