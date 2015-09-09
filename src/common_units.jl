macro units(name, args...)
  kwargs = Any[]
  for arg in args
    push!(kwargs, arg.args)
  end
  dimensionality = _create_dimensionality(;kwargs...)
  :(Unit{$name, $dimensionality})
end
typealias meter @units(:meter, length=1)
typealias gram @units(:gram, mass=1)
typealias second @units(:second, time=1)
typealias ampere @units(:ampere, electric_current=1)
typealias kelvin @units(:kelvin, temperature=1)
typealias mol @units(:mol, amount=1)
typealias candela @units(:candela, luminosity=1)
typealias radian @units(:radian, angle=1)
typealias steradian @units(:steradian, solid_angle=1)
typealias newton @units :newton length=1 mass=1 time=-2
typealias joule @units :joule length=2 mass=1 time=-2
typealias volt @units :volt mass=1 length=2 time=-3 electric_current=-1

function define_other_magnitudes(unit, prefixes)
  result = quote end
  for (prefix, factor) in prefixes
    name = symbol("$prefix$(unit.parameters[1])")
    dims = unit.parameters[2]
    exponent = factor
    block = quote
      typealias $name Unit{$(parse(":" * string(name))), $dims}
      conversion_factor{T <: FloatingPoint}(::Type{$name}, ::Type{T}) =
          convert(T, 10)^$exponent
      conversion_factor(::Type{$name}) = conversion_factor($name, FloatingPoint)
    end
    append!(result.args, block.args)
  end
  result
end
function define_other_magnitudes(unit)
  prefixes = {
    :peta => 15, :tera => 12, :giga => 9, :mega => 6,
    :kilo => 3, :hecto => 2, :deca => 10,
    :deci => -1, :centi => -2, :milli => -3,
    :micro => -6, :nano => -9, :femto => -12,
    :atto => -15
  }
  define_other_magnitudes(unit, prefixes)
end

for unit in [meter, gram, second, ampere, kelvin, mol, candela, radian,
  steradian, joule, newton, volt]
  eval(define_other_magnitudes(unit))
  @eval conversion_factor(::Type{$unit}) = 1
end
conversion_factor{T <: Unit}(::Type{T}, ::Type{T}) = 1
conversion_factor{N1, N2, D}(::Type{Unit{N1, D}}, ::Type{Unit{N2, D}}) =
  conversion_factor(Unit{N1, D}) / conversion_factor(Unit{N2, D})
conversion_factor{N1, N2, D, T}(::Type{Unit{N1, D}}, ::Type{Unit{N2, D}}, ::Type{T}) =
  conversion_factor(Unit{N1, D}, T) / conversion_factor(Unit{N2, D}, T)
