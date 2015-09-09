import Base: *, /, inv
export @dimensionality, Length, Time, Mass, Weight, Area, Volume, Velocity
export Acceleration, Density, Force, Energy, ElectricPotential
const DIMENSIONS = (
  :length, :mass, :time, :electric_current, :temperature, :amount,
  :luminosity, :angle, :solid_angle
)
@eval abstract Dimensionality{$(DIMENSIONS...)}


function _create_dimensionality(;kwargs...)
  dimensions = zeros(Int, length(DIMENSIONS))
  given = zeros(Bool, length(DIMENSIONS))
  for (name, value) in kwargs
    index = findfirst(DIMENSIONS, name)
    if index == 0
      error("$name is not  a known dimension ($DIMENSIONS)")
    end
    if given[index] == true
      error("$name given twice")
    end
    dimensions[index] = value
  end
  :(Dimensionality{$(dimensions...)})
end

macro dimensionality(args...)
  kwargs = Any[]
  for arg in args
    push!(kwargs, arg.args)
  end
  _create_dimensionality(;kwargs...)
end

typealias Undimensional @dimensionality
typealias Length @dimensionality length=1
typealias Time @dimensionality time=1
typealias Mass @dimensionality mass=1
typealias Weight @dimensionality mass=1

typealias Area @dimensionality length=2
typealias Volume @dimensionality length=3
typealias Velocity @dimensionality length=1 time=-1
typealias Acceleration @dimensionality length=1 time=-2
typealias Density @dimensionality length=-3 mass=1
typealias Force @dimensionality length=1 mass=1 time=-2
typealias Energy @dimensionality length=2 mass=1 time=-2
typealias ElectricPotential
  @dimensionality mass=1 length=2 time=-3 electric_current=-1

const DIMS2 = tuple([symbol(string(u) * "1") for u in DIMENSIONS]...)
@eval begin
  function *{$(hcat(DIMENSIONS..., DIMS2...)...)}(
    ::Type{Dimensionality{$(DIMENSIONS...)}},
    ::Type{Dimensionality{$(DIMS2...)}})
    Dimensionality{([$(DIMENSIONS...)] + [$(DIMS2...)])...}
  end
  function /{$(hcat(DIMENSIONS..., DIMS2...)...)}(
    ::Type{Dimensionality{$(DIMENSIONS...)}},
    ::Type{Dimensionality{$(DIMS2...)}})
    Dimensionality{([$(DIMENSIONS...)] - [$(DIMS2...)])...}
  end
  function ^{$(DIMENSIONS...)}(
    ::Type{Dimensionality{$(DIMENSIONS...)}}, n::Integer)
    Dimensionality{[$(DIMENSIONS...)]*n...}
  end
  function inv{$(DIMENSIONS...)}(::Type{Dimensionality{$(DIMENSIONS...)}})
    Dimensionality{-[$(DIMENSIONS...)]...}
  end
end


