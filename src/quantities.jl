import Base: *, /
*{UNIT <: Unit}(number::Number, ::Type{UNIT})=
   Quantity{typeof(number), UNIT}(number)
/{UNIT <: Unit}(::Type{UNIT}, number::Number)= (1/number) * UNIT
*{UNIT <: Unit}(::Type{UNIT}, number::Number)= number * UNIT
-(::Type{Undimensional}, number::Number) = number - 1
-(number::Number, ::Type{Undimensional}) = number - 1
+(::Type{Undimensional}, number::Number) = number + 1
+(number::Number, ::Type{Undimensional}) = number + 1
*(::Type{Undimensional}, number::Number) = number
*(number::Number, ::Type{Undimensional}) = number
/(::Type{Undimensional}, number::Number) = number
/(number::Number, ::Type{Undimensional}) = number
