module HashCast::Metadata
  class Attribute
    attr_reader :name, :caster, :options
    attr_accessor :children

    def initialize(name, caster, options)
      @name      = name
      @caster    = caster
      @options   = options
      @children  = []
    end

    def has_children?
      !children.empty?
    end

    def required?
      !optional?
    end

    def optional?
      !!options[:optional]
    end

    def allow_nil?
      !!options[:allow_nil]
    end

  end
end
