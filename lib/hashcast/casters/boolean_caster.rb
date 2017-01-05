class HashCast::Casters::BooleanCaster
  REAL_BOOLEANS = [TrueClass, FalseClass]
  TRUE_VALUES   = ['1', 'true', 'on', 1]
  FALSE_VALUES  = ['0', 'false', 'off', 0]

  def self.cast(value, attr_name, options = {})
    return value if REAL_BOOLEANS.include?(value.class)
    return true  if TRUE_VALUES.include?(value)
    return false if FALSE_VALUES.include?(value)
    raise HashCast::Errors::CastingError, "should be a boolean"
  end

end
