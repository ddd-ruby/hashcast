class HashCast::Casters::SymbolCaster
  MAX_SYMBOL_LENGTH = 1000

  def self.cast(value, attr_name, options = {})
    return value              if value.is_a?(Symbol)
    return cast_string(value) if value.is_a?(String)
    raise HashCast::Errors::CastingError, "should be a symbol"
  end

  def self.cast_string(value)
    return value.to_sym if value.length <= MAX_SYMBOL_LENGTH
    raise HashCast::Errors::CastingError, "is too long to be a symbol (#{MAX_SYMBOL_LENGTH} max.)"
  end

end
