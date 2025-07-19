using Melody
using Test

@testset "Melody.jl" begin
    mss = makeMelodySampleSpace(UInt8(12), UInt8(5))	# allowZero::Bool = true
    
    lowest_melody = Int8(-5) * ones(Int8, 12)           # melody with the lowest possible index
    lowest_index = getMelodyIndex(mss, lowest_melody)   # must be 0x0000000000000001

    @test Int(lowest_index) == 1 || "Test 1a failed: lowest melody index MUST be 1"

    highest_melody = Int8(+5) * ones(Int8, 12)           # melody with the highest possible index
    highest_index = getMelodyIndex(mss, highest_melody)   # must be 0x000002dab8e89691

    @test Int(highest_index) == 11^12 || "Test 1b failed: highest melody index MUST be 11^12"

end
