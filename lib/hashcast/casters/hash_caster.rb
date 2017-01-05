class HashCast::Casters::HashCast

  def self.cast(value, attr_name, options = {})
    return value if value.is_a?(Hash)
    raise HashCast::Errors::CastingError, "should be a hash"
  end

end
