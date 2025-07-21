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

# 2. Generate random sample 

sample = generateSample(mss, UInt64(1000))

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


