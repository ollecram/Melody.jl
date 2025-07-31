using Melody
using Random

# 1. Basic tests

mss = makeMelodySampleSpace(UInt8(12), UInt8(5))

lowest_melody  = Int8(-5) * ones(Int8, 12) # melody with the lowest possible index
highest_melody = Int8(+5) * ones(Int8, 12) # melody with the highest possible index

lowest_index  = getMelodyIndex(mss, lowest_melody)   # must be 0x0000000000000000
highest_index = getMelodyIndex(mss, highest_melody)  # must be 0x000002dab8e89690

(Int(lowest_index)  == 0        ) || println("Int(lowest index) MUST be 0")
(Int(highest_index) == 11^12 - 1) || println("Int(lowest index) MUST be $(11^12 - 1)")

test_lowest  = getMelodyFromIndex(mss, lowest_index)
(test_lowest  == lowest_melody)  || println("Test_lowest ERROR: \n$(lowest_melody) != \n$(test_lowest)")

test_highest = getMelodyFromIndex(mss, highest_index)
(test_highest == highest_melody) || println("Test_highest ERROR: \n$(highest_melody) != \n$(test_highest)")


# 2. Tests focused on a melody's equivalence class 

mss_withZero    = makeMelodySampleSpace(UInt8(8), UInt8(5); allowZero = true)
mss_withoutZero = makeMelodySampleSpace(UInt8(8), UInt8(5); allowZero = false)

(matrix1, vector1) = allMelodies(mss_withZero)
    #> closed: 9377467, circular: 97464799, both: 9377467   [with mss_withZero, ALL closed are also circular]

(matrix2, vector2) = allMelodies(mss_withoutZero)
    #> closed: 4161710, circular: 39318000, both: 0         [with mss_withoutZero, closed cannot be circular]

dict1 = melodyClassesRepresentative(mss_withZero, matrix1, vector1)
	#> melodyClassesRepresentative() : 116894082 NON-CIRCULAR melodies in the sample space
	#> 97464799-element Dictionaries.Dictionary{UInt64, UInt64}

dict2 = melodyClassesRepresentative(mss_withoutZero, matrix2, vector2)
	#> melodyClassesRepresentative() : found 60682000 NON-CIRCULAR melodies in the sample space
	#> 39318000-element Dictionaries.Dictionary{UInt64, UInt64}

# Below, focus on melodies whose index is found before the middle of a sorted list of CIRCULAR melodies     

sorted_keys_1 = sort(collect(keys(dict1))); picks_1 = [div(length(sorted_keys_1), k) for k in [2,3,5,7]]
sorted_keys_2 = sort(collect(keys(dict2))); picks_2 = [div(length(sorted_keys_2), k) for k in [2,3,5,7]]

melody_indices_1 = [sorted_keys_1[picks_1[k]] for k in 1:4]
melody_indices_2 = [sorted_keys_2[picks_2[k]] for k in 1:4]

# Report results, showing how the cardinality of equivalence classes can vary
println("\n ======= Data on 4 Equiv classes with mss.AVSPWRTPN including the ZERO =======") 
for melody_index in melody_indices_1
    eqClass = melodyIndexToEquivalenceClass(dict1, melody_index)
    println("\t melody index: $(melody_index), Equiv class Cardinality: $(length(eqClass))") 
end
#> melody index: 107179439, Equiv class Cardinality: 8	|  In this short sample of 4 cases, all
#> melody index:  73413378, Equiv class Cardinality: 8	|  the examined equivalence classes have
#> melody index:  46371675, Equiv class Cardinality: 8	|  the MAXIMUM possible cardinality (8)
#> melody index:  33609929, Equiv class Cardinality: 8	|  

println("\n ===== Data on 4 Equiv classes with mss.AVSPWRTPN NOT including the ZERO =====") 
for melody_index in melody_indices_2
    eqClass = melodyIndexToEquivalenceClass(dict2, melody_index)
    println("\t melody index: $(melody_index), Equiv class Cardinality: $(length(eqClass))") 
end
#> melody index:  49999100, Equiv class Cardinality: 8	|  In this short sample of 4 cases, all
#> melody index:  34499651, Equiv class Cardinality: 8	|  the examined equivalence classes have
#> melody index:  21391787, Equiv class Cardinality: 8	|  the MAXIMUM possible cardinality (8)
#> melody index:  15781027, Equiv class Cardinality: 8	|

# Below, find instructions on how to make use of the above results ( n o t   v e r i f i e d ):
#
#   julia> include("Melody.jl/test/runtests.jl") 
#   julia> (matrix1, vector1, dict1, melody_index_1, eqClass1) = results_1
#   julia> (matrix2, vector2, dict2, melody_index_2, eqClass2) = results_2

# 3. Generate random sample 

# sample = generateSample(mss, UInt64(1000))

#==============================================================================================
using Test

@testset "Melody.jl" begin
    mss = makeMelodySampleSpace(UInt8(12), UInt8(5))	# allowZero::Bool = true
    
    lowest_melody = Int8(-5) * ones(Int8, 12)           # melody with the lowest possible index
    lowest_index = getMelodyIndex(mss, lowest_melody)   # must be 0x0000000000000001

    @test Int(lowest_index) == 1 || "Test 1a failed: lowest melody index MUST be 1"

    highest_melody = Int8(+5) * ones(Int8, 12)           # melody with the highest possible index
    highest_index = getMelodyIndex(mss, highest_melody)   # must be 0x000002dab8e89691

    @test Int(highest_index) == mss.spaceSize || "Test 1b failed: highest melody index MUST be 11^12"

end
================================================================================================#


