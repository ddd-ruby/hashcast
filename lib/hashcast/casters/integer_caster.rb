class HashCast::Casters::IntegerCaster

  def self.cast(value, attr_name, options = {})
    return value              if value.is_a?(Integer)
    return cast_string(value) if value.is_a?(String)
    raise HashCast::Errors::CastingError, "should be a integer"
  end

  def self.cast_string(value)
    Integer(value)
  rescue ArgumentError => e
    raise HashCast::Errors::CastingError, "is invalid integer"
  end

end
