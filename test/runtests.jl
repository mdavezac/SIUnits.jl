module TestUnits
using FactCheck
using Units


facts("dimensionality") do
  @fact Length * Length --> @dimensionality length:2
  @fact Length * Time --> @dimensionality length:1 time:1
  @fact Length * Time --> not(@dimensionality length:2 time:1)
  @fact Energy / Length --> @dimensionality length:1 mass:1 time:-2
  @fact Energy / Length^2 * Time^2 / Mass --> Nondimensional
  @fact inv(Energy) --> @dimensionality length:-2 mass:-1 time:2
end
# @fact conversion_factor(Units.kilometer, Units.gigameter) == 1e-6
# @pending @test_throws Exception Units.conversion_factor(Units.kilometer, Units.gigagram)

FactCheck.exitstatus()
end
