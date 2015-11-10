module TestUnits
using FactCheck
using Units
import Units.conversion_factor


facts("dimensionality") do
  @fact sum([abs(u) for u in Length.parameters]) --> 1
  @fact sum([abs(u) for u in (Length * Length).parameters]) --> 2
  @fact Length * Length --> @dimensionality length:2
  @fact Length * Time --> @dimensionality length:1 time:1
  @fact Length * Time --> not(@dimensionality length:2 time:1)
  @fact Energy / Length --> @dimensionality length:1 mass:1 time:-2
  @fact Energy / Length^2 * Time^2 / Mass --> Nondimensional
  @fact inv(Energy) --> @dimensionality length:-2 mass:-1 time:2
end

typealias Centigram Units.@units :centigram mass=1
conversion_factor(::Type{Centigram}) = 1//10

typealias Bouligram Units.@units :bouligram mass=1
conversion_factor(::Type{Bouligram}) = 1.05
facts("units") do
  @fact Units.conversion_factor(Units.Gram) --> 1//1000
  @fact Units.conversion_factor(Units.Kilogram, Units.Gram) --> 1000
  @fact Units.conversion_factor(Units.Kilogram, Units.Gram) --> 1000
  @fact Units.conversion_factor(Units.Kilogram, Centigram) --> 10
  @fact Units.conversion_factor(Units.Gram, Centigram) --> 1//100
  @fact Units.conversion_factor(Bouligram) --> roughly(1.05)
  @fact Units.conversion_factor(Units.Gram, Bouligram) -->
    roughly((1//1000) / 1.05)
  @fact_throws Exception Units.conversion_factor(Units.Meter, Units.Kilogram)
end

FactCheck.exitstatus()
end
