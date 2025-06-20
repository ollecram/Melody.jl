using Melody
using Documenter

DocMeta.setdocmeta!(Melody, :DocTestSetup, :(using Melody); recursive=true)

makedocs(;
    modules=[Melody],
    authors="Ollecram-Friends",
    sitename="Melody.jl",
    format=Documenter.HTML(;
        canonical="https://ollecram.github.io/Melody.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/ollecram/Melody.jl",
    devbranch="main",
)
