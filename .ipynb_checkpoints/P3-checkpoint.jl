using ITensors, ITensorMPS
N = 44
shot_count = 4096
#s = siteinds("Qubit",2, conserve_qns=false)
s = siteinds("Qubit", N)
Psi_0 = MPS(s, "0")
gates = ITensor[]

#open("P4_golden_mountain.qasm", "r") do file

function extract_qubits(line::String)
    matches = collect(eachmatch(r"q\[(\d+)\]", line))
    return [parse(Int, m.captures[1]) for m in matches] .+1
end

#gate_names = Dict{String, String}()
gate_map = Dict("u3" => "Rn", "cz" => "CZ")

open("P3__sharp_peak.qasm", "r") do file
    for i in 1:3
        readline(file)
    end
    for gate_line in eachline(file)
        gate_nums = extract_qubits(gate_line)
        gate_string = gate_map[gate_line[1:2]]
        #println(gate_nums)
        if gate_string == "Rn"
            # Extract the u3 gate's 3 arguments using regex
            match_ = match(r"u3\(([^,]+),([^,]+),([^,]+)\)", gate_line)
            if match_ != nothing
                args = [eval(Meta.parse(match_.captures[i])) for i in 1:3]
                push!(gates,op("Rn",s[gate_nums[1]]; θ = args[1], ϕ = args[2], λ = args[3]))  
                #println("Gate: $gate_string, Arguments: $args")
            end
        elseif gate_string == "cz"
            # cz gate has no parameters
            push!(gates, op("CZ", s[gate_nums[1]], s[gate_nums[2]]))
            #println("Gate: $gate_string, Arguments: []")
        end
       
    end
end
#push!(gates,op("Rn" ,s[1]; θ = 2.0057649468265417, ϕ = -0.8817436123352573, λ = 1.7982698223463016))
#push!(gates,op("H",s[1]))
#push!(gates,op("CX",s[1],s[2]))
#gate = op("CX", s[1],s[2])
Psi = apply(gates, Psi_0, cutoff=1e-15)


Psi = orthogonalize(Psi, 1)
#counts = Dict{Vector{Int64}, Int}()
counts = Dict{String, Int}()

function get_bit_string(vector)
    vector .-= 1
    bit_string = join(string.(vector))
    return bit_string
end

for j in 1:shot_count
    bit_string = get_bit_string(sample(Psi))
    counts[bit_string] = get(counts, bit_string, 0) + 1
    #counts[bit_string] += 1 
end

function max_tie_info(dict::Dict)
    max_val = maximum(values(dict))
    tied_keys = [k for (k, v) in dict if v == max_val]
    return length(tied_keys) > 1, tied_keys
end
#println(inner(Psi

#a = sample(Psi)
#b = sample(Psi)

# using ITensors, ITensorMPS

# N = 4
# s = siteinds("Qubit", N)

# # Make all of the operators
# X = ops(s, [("X", n) for n in 1:N])
# H = ops(s, [("H", n) for n in 1:N])
# CX = ops(s, [("CX", n, m) for n in 1:N, m in 1:N])

# # Start with the state |0000...⟩
# Psi_0 = MPS(s, "0")

# # Change to the state |1010...⟩
# gates = [X[n] for n in 1:2:N]
# Psi = apply(gates, Psi_0; cutoff=1e-15)
# #@assert inner(ψ, MPS(s, n -> isodd(n) ? "1" : "0")) ≈ 1

# # Change to the state |10111011...⟩
# append!(gates, [CX[n, n + 3] for n in 1:4:(N - 3)])
# Psi = apply(gates, Psi_0; cutoff=1e-15)
# #@assert inner(ψ, MPS(s, ["1", "0", "1", "1", "1", "0", "1", "1", "1", "0"])) ≈ 1

# # Change the state |10111011...⟩ to the (|+⟩, |-⟩) basis
# append!(gates, [H[n] for n in 1:N])
# Psi = apply(gates, Psi_0; cutoff=1e-15)




# using ITensors

# # Define a 2-qubit system
# sites = siteinds("Qubit", 2)

# # Initial state |00⟩
# psi0 = productMPS(sites, ["0", "0"])

# # Apply Hadamard on qubit 1
# psi1 = apply(op("H", sites[1]), psi0, 1)

# # Apply CNOT (control=1, target=2)
# psi2 = apply(op("CNOT", sites[1], sites[2]), psi1, (1, 2))

# # Sample bitstrings from the final MPS
# samples = sample(psi2, sites; n_samples=10)

# # Print sampled bitstrings
# for s in samples
#     println(join(s))
# end