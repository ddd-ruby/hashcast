class HashCast::Config
  attr_accessor :input_keys, :output_keys

  def input_keys
    @input_keys || :symbol
  end

  def output_keys
    @output_keys || :symbol
  end
end
