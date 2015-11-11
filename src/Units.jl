module Units

const DIMENSIONS = (
  :length, :mass, :time, :electric_current, :temperature, :amount,
  :luminosity, :angle, :solid_angle
)

include("dimensionality.jl")

abstract Unit{NAME, DIMENSION <: Dimensionality}
include("common_units.jl")

let params = [:($d <: Unit) for d in DIMENSIONS]
  eval(parse(string(:(abstract System{$(params...)}))))
end

typealias SI System{
  Meter, Kilogram, Second, Ampere, Kelvin, Mol, Candela, Radian, Steradian}

type Quantity{T <: Number, UNIT <: Unit, SYSTEM <: System} <: Number
  value :: T
end

include("quantities.jl")
end
