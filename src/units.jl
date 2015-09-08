module Units

const DIMENSIONS = (
  :length, :mass, :time, :electric_current, :temperature, :amount,
  :luminosity, :angle, :solid_angle
)

include("dimensionality.jl")

abstract Unit{NAME, DIMENSION <: Dimensionality}
type Quantity{T <: Number, UNIT <: Unit}
  value :: T
end

include("common_units.jl")


end
