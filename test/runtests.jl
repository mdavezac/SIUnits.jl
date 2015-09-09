using Base.Test
include(joinpath(Pkg.dir("SIUnits.jl"), "src", "units.jl"))

if VERSION <= v"0.3-"
    macro test_throws_compat(a,b)
        esc(:(@test_throws $b))
    end
else
    macro test_throws_compat(a,b)
        esc(:(@test_throws $a $b))
    end
end

if VERSION <= v"0.4.0-dev+3338"
    const AssertionError = ErrorException
end

@test Units.conversion_factor(Units.kilometer, Units.gigameter) == 1e-6
@test_throws Exception Units.conversion_factor(Units.kilometer, Units.gigagram)
