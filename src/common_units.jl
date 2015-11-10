macro units(name, args...)
  kwargs = Any[]
  for arg in args
    push!(kwargs, arg.args)
  end
  dimensionality = _create_dimensionality(;kwargs...)
  :(Unit{$name, $dimensionality})
end
typealias Meter @units(:meter, length=1)
typealias Gram @units(:gram, mass=1)
typealias Kilogram @units(:Kilogram, mass=1)
typealias Second @units(:second, time=1)
typealias Ampere @units(:ampere, electric_current=1)
typealias Kelvin @units(:kelvin, temperature=1)
typealias Mol @units(:mol, amount=1)
typealias Candela @units(:candela, luminosity=1)
typealias Radian @units(:radian, angle=1)
typealias Steradian @units(:steradian, solid_angle=1)
typealias Newton @units :newton length=1 mass=1 time=-2
typealias Joule @units :joule length=2 mass=1 time=-2
typealias Volt @units :volt mass=1 length=2 time=-3 electric_current=-1

conversion_factor{N1, N2, D1 <: Dimensionality, D2 <: Dimensionality}(
  ::Type{Unit{N1, D1}}, ::Type{Unit{N2, D2}}) =
  D1 == D2 ?
    conversion_factor(Unit{N1, D1}) / conversion_factor(Unit{N2, D2}):
    error("Incompatible units")

conversion_factor{T <:Unit}(::Type{T}, ::Type{T}) = 1
conversion_factor(::Type{Gram}) = 1//1000
for unit in [Meter, Kilogram, Second, Ampere, Kelvin, Mol, Candela, Radian,
  Steradian, Newton, Joule, Volt]
  @eval conversion_factor(::Type{$unit}) = 1
end
