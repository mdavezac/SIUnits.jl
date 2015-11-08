module Units

const DIMENSIONS = (
  :length, :mass, :time, :electric_current, :temperature, :amount,
  :luminosity, :angle, :solid_angle
)

include("dimensionality.jl")

abstract Unit{NAME, DIMENSION <: Dimensionality}
include("common_units.jl")

type Quantity{T <: Number, UNIT <: Unit} <: Number
  value :: T
end
include("quantities.jl")
end
