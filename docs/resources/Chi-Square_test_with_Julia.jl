using HypothesisTests

function test_large_simulation(total_simulations::Int64)
    num_outcomes = 1_000_000_000
    num_blocks = 1_000  # Group outcomes into 1,000 blocks to save memory
    block_size = div(num_outcomes, num_blocks)
    
    # Initialize counts for each block
    block_counts = zeros(Int64, num_blocks)
    
    # Simulate data in a stream (Example using a uniform pseudo-random generator)
    for _ in 1:total_simulations
        # Simulate an outcome between 1 and 1,000,000,000
        outcome = rand(1:num_outcomes) 
        
        # Map the outcome to its respective block (1 to 1,000)
        block_idx = div(outcome - 1, block_size) + 1
        block_counts[block_idx] += 1
    end
    
    # Under the null hypothesis, each block has the exact same probability
    expected_prob = 1.0 / num_blocks
    expected_counts = fill(total_simulations * expected_prob, num_blocks)
    
    # Perform the Pearson Chi-Square Test
    test_result = ChisqTest(block_counts, expected_counts)
    return test_result
end

# Run the test with 5 billion simulations
# (Rule of thumb: expected count per bin should be >= 5)
result = test_large_simulation(5_000_000_000)
println(result)

