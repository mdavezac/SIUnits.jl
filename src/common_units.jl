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

prefixes = {
  :peta => 15, :tera => 12, :giga => 9, :mega => 6,
  :kilo => 3, :hecto => 2, :deca => 10,
  :deci => -1, :centi => -2, :milli => -3,
  :micro => -6, :nano => -9, :femto => -12,
  :atto => -15
}
for unit in [:meter, :gram, :second]
  for (prefix, factor) in prefixes
    let
       local name = symbol("$prefix$unit")
       local dims = @eval $unit.parameters[2]
       local exponent = factor
       @eval begin
         typealias $name Unit{$(parse(":" * string(name))), $dims}
         conversion_factor{T <: FloatingPoint}(::Type{$name}, ::Type{T}) =
             convert(T, 10)^$exponent
         conversion_factor(::Type{$name}) = conversion_factor($name, FloatingPoint)
       end
    end
  end
  @eval conversion_factor(::Type{$unit}) = 1
end
conversion_factor{T <: Unit}(::Type{T}, ::Type{T}) = 1
conversion_factor{N1, N2, D}(::Type{Unit{N1, D}}, ::Type{Unit{N2, D}}) =
  conversion_factor(Unit{N1, D}) / conversion_factor(Unit{N2, D})
conversion_factor{N1, N2, D, T}(::Type{Unit{N1, D}}, ::Type{Unit{N2, D}}, ::Type{T}) =
  conversion_factor(Unit{N1, D}, T) / conversion_factor(Unit{N2, D}, T)
