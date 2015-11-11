import Base: eltype, call, promote_rule
export quantity, unit, value, unit_system

quantity{T <: Number, UNIT <: Unit, SYSTEM <: System}(
  x::T, ::Type{UNIT}, ::Type{SYSTEM} = SI) = Quantity{T, UNIT, SYSTEM}(x)

value(q::Quantity) = q.value
unit{T, UNIT, SYSTEM}(::Quantity{T, UNIT, SYSTEM}) = UNIT
unit_system{T, UNIT, SYSTEM}(::Quantity{T, UNIT, SYSTEM}) = SYSTEM
eltype{T, UNIT, SYSTEM}(::Quantity{T, UNIT, SYSTEM}) = T

promote_rule(::Type{Irrational}, ::Type{Quantity{Irrational}}) =
    Quantity{Irrational}
promote_rule(::Type{Bool}, ::Type{Quantity{Bool}}) = Quantity{Bool}
promote_rule{T <: Number}(::Type{T}, ::Type{Quantity{T}}) = Quantity{T}
promote_rule{TT, U, S}(::Type{Bool}, ::Type{Quantity{TT, U, S}}) =
    Quantity{promote_type(Bool, TT)}
promote_rule{T, TT, U, S}(::Type{Irrational{T}}, ::Type{Quantity{TT, U, S}}) =
    Quantity{promote_type(Bool, TT)}
promote_rule{T <: Number, TT, U, S}(::Type{T}, ::Type{Quantity{TT, U, S}}) =
    Quantity{promote_type(T, TT)}

# One unspecified, units, one concrete (unspecified occurs as the promotion
# result from the rules above)
promote_rule{T, TT, U, S}(::Type{Quantity{T}}, ::Type{Quantity{TT, U, S}}) =
    Quantity{promote_type(T,S)}

convert{T<:Number, TT, U, S}(::Type{Quantity{T}}, x::Quantity{TT, U, S}) =
  Quantity{T, U, S}(convert(T, x.value))
# /{UNIT <: Unit}(::Type{UNIT}, number::Number)= (1/number) * UNIT
# *{UNIT <: Unit}(::Type{UNIT}, number::Number)= number * UNIT
# -(::Type{Undimensional}, number::Number) = number - 1
# -(number::Number, ::Type{Undimensional}) = number - 1
# +(::Type{Undimensional}, number::Number) = number + 1
# +(number::Number, ::Type{Undimensional}) = number + 1
# *(::Type{Undimensional}, number::Number) = number
# *(number::Number, ::Type{Undimensional}) = number
# /(::Type{Undimensional}, number::Number) = number
# /(number::Number, ::Type{Undimensional}) = number
