class HashCast::Casters::DateTimeCaster

  def self.cast(value, attr_name, options = {})
    return value               if value.is_a?(DateTime)
    return value.to_datetime   if value.is_a?(Time)
    return cast_string(value)  if value.is_a?(String)
    raise HashCast::Errors::CastingError, "should be a datetime"
  end

  def self.cast_string(value)
    DateTime.parse(value)
  rescue ArgumentError => e
    raise HashCast::Errors::CastingError, "is invalid datetime"
  end
end
