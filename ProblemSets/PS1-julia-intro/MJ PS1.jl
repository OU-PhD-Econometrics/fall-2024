# Econ 6343 - Econometrics PS-1
using Pkg
Pkg.add("JLD")
Pkg.add("Random")
Pkg.add("LinearAlgebra")
Pkg.add("Statistics")
Pkg.add("CSV")
Pkg.add("DataFrames")
Pkg.add("FreqTables")
Pkg.add("Distributions")
Pkg.add("Kronecker")
using CSV
using DataFrames
using Distributions
using FreqTables
using JLD
using Kronecker
using LinearAlgebra
using Random
using Statistics
# 0. gitHub setup 
# 1. Initializing variables and practice with basic matrix operations. 
# (a) Create four matrices of random numbers. 
Random.seed!(1234)
A = rand(Uniform(-5, 10), 10, 7)
B = rand(Normal(-2, 15), 10, 7)
C = [A[1:5, 1:5] B[1:5, 6:7]]
D = [A[i, j] ≤ 0 ? A[i, j] : 0 for i in 1:10, j in 1:7]
# Print the matrices to verify
println("Matrix A:\n", A)
println("Matrix B:\n", B)
println("Matrix C:\n", C)
println("Matrix D:\n", D)

# (b) Use built-in-Julia to number of element of A 
num_elements_A = length(A)
println("Number of elements in matrix A: ", num_elements_A)
# (c) Unique elements of D
num_unique_elements_D = length(unique(vec(D)))
println("Number of unique elements in matrix D: ", num_unique_elements_D)
# (d) Create new matrix E 
E = reshape(vec(B), 10, 7)
println("Matrix E:\n", E)
# (e) Create a new array F. 
F = cat(A, B, dims=3)
#(f) Use the permutedims function to twist F 
F_permuted = permutedims(F, (2,1,3))
# (g) Create matrix G 
G = Kron(B,C)
println("Kronecker product of B and C: ", G)
# Attempt to compute C⊗F
try
    Kron(C,F)
catch e
    println("Error: ", e)
end

# (h) save all matrices file named matrixpractice
save("matrixpractice.jld", "A" => A, "B" => B, "C" => C, "D" => D, "E" => E, "F" => F, "G" => G)
# (i) Save only the matrices ABCD
save("firstmatrix.jld", "A" => A, "B" => B, "C" => C, "D" => D)
# (j) Export C as a csv file called Cmatrix 
C_df = DataFrame(C)
CSV.write("Cmatrix.csv", C_df)
# (k) Export D as a tab-delimited .dat file called Dmatrix
D_df = DataFrame(D)
CSV.write("Dmatrix.dat", D_df, delim='\t')
#(i) Wrap a function definition around all of the code for q.1. 
function q1()
    Random.seed!(1234)
    A = rand(Uniform(-5, 10), 10, 7)
    B = rand(Normal(-2, 15), 10, 7)
    C = [A[1:5, 1:5] B[1:5, 6:7]]
    D = A .* (A .≤ 0)
    E = reshape(B, :)
    F = cat(A, B, dims=3)
    F_permuted = permutedims(F, (2,1,3))
    G = kron(B, C)
    save("matrixpractice.jld", "A" => A, "B" => B, "C" => C, "D" => D, "E" => E, "F" => F, "G" => G)
    save("firstmatrix.jld", "A" => A, "B" => B, "C" => C, "D" => D)
    CSV.write("Cmatrix.csv", DataFrame(C))
    CSV.write("Dmatrix.dat", DataFrame(D), delim='\t')
    return A, B, C, D
end
A, B, C, D = q1()

# 2. Practice with loops and comprehension 
#(a) Write a loop or use a comprehension that computes the element-by-element product of A and B
# Using a loop or comprehension
AB = [A[i,j] * B[i,j] for i in 1:10, j in 1:7]
# Without a loop or comprehension
AB2 = A .* B
#(b) 
Cprime = []
for i in 1:size(C,1)
    for j in 1:size(C,2)
        if -5 ≤ C[i,j] ≤ 5
            push!(Cprime, C[i,j])
        end
    end
end
Cprime = hcat(Cprime...)
# Without a loop
Cprime2 = vec(C[(C .≥ -5) .& (C .≤ 5)])cd