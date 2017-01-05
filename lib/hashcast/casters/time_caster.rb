class HashCast::Casters::TimeCaster

  def self.cast(value, attr_name, options = {})
    return value              if value.is_a?(Time)
    return cast_string(value) if value.is_a?(String)
    raise HashCast::Errors::CastingError, "#{value} should be a time"
  end

  def self.cast_string(value)
    Time.parse(value)
  rescue ArgumentError => e
    raise HashCast::Errors::CastingError, "#{value} is invalid time"
  end

end
