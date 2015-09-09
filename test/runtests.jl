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

@test is(Units.Length * Units.Length, Units.@dimensionality length:2)
@test is(Units.Length * Units.Time, Units.@dimensionality length:1 time:1)
@test !is(Units.Length * Units.Time, Units.@dimensionality length:2 time:1)
@test is(Units.Energy / Units.Length, Units.@dimensionality length:1 mass:1 time:-2)
@test is(Units.Energy / Units.Length^2 * Units.Time^2 / Units.Mass, Units.Undimensional)
@test is(inv(Units.Energy), Units.@dimensionality length:-2 mass:-1 time:2)
@test Units.conversion_factor(Units.kilometer, Units.gigameter) == 1e-6
@test_throws Exception Units.conversion_factor(Units.kilometer, Units.gigagram)
