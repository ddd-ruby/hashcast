class HashCast::AttributesCaster
  attr_reader :attributes, :options

  def initialize(attributes, options)
    @attributes = attributes
    @options    = options
  end

  def cast(input_hash)
    casted_hash = {}

    hash_keys = get_keys(input_hash)
    attributes.each do |attribute|
      if hash_keys.include?(attribute.name)
        begin
          casted_value = cast_attribute(attribute, input_hash)
          casted_hash[cast_key(attribute.name, options)] = casted_value
        rescue HashCast::Errors::AttributeError => e
          e.add_namespace(attribute.name)
          raise e
        end
      else
        raise HashCast::Errors::MissingAttributeError.new("should be given", attribute.name) if attribute.required?
      end
    end

    if !options[:skip_unexpected_attributes]
      check_unexpected_attributes_not_given!(hash_keys, casted_hash.keys)
    end

    casted_hash
  end

  private

  def cast_attribute(attribute, hash)
    value = get_value(hash, attribute.name)
    return nil if value.nil? && attribute.allow_nil?

    casted_value = attribute.caster.cast(value, attribute.name, attribute.options)

    if attribute.has_children?
      return cast_children(casted_value, attribute)
    end
    if caster = attribute.options[:caster]
      return cast_children_with_caster(casted_value, attribute, caster)
    end

    casted_value
  end

  def cast_children(value, attribute)
    caster = self.class.new(attribute.children, options)
    cast_children_with_caster(value, attribute, caster)
  end

  def cast_children_with_caster(value, attribute, caster)
    return caster.cast(value) if attribute.caster != HashCast::Casters::ArrayCaster

    value.map do |val|
      caster.cast(val)
    end
  end

  def cast_key(value, options)
    return value      if options[:output_keys] == :symbol
    return value.to_s if options[:output_keys] == :string
  end

  def get_keys(hash)
    return hash.keys if same_in_out_key_format?
    hash.keys.map(&:to_sym)
  end

  def get_value(hash, key)
    return hash[key]        if same_in_out_key_format?
    return hash[key.to_sym] if options[:input_keys] == :symbol
    hash[key.to_s]
  end

  def check_unexpected_attributes_not_given!(input_hash_keys, casted_hash_keys)
    unexpected_keys = keys_diff(input_hash_keys, casted_hash_keys)
    unless unexpected_keys.empty?
      raise HashCast::Errors::UnexpectedAttributeError.new("is not valid attribute name", unexpected_keys.first)
    end
  end

  def same_in_out_key_format?
    options[:input_keys] == options[:output_keys]
  end

  def keys_diff(input_hash_keys, casted_hash_keys)
    return (input_hash_keys - casted_hash_keys) if same_in_out_key_format?
    return (input_hash_keys - casted_hash_keys) if options[:output_keys] == :symbol # same for symbol
    return (input_hash_keys - casted_hash_keys.map(&:to_sym)) if options[:output_keys] == :string
  end
end
