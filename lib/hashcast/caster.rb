# Include this module to create your caster
#
# Example caster:
#   class ContactCaster
#     include HashCast::Caster
#
#     attributes do
#       hash :contact do
#         string   :name
#         integer  :age, optional: true
#         float    :weight
#         date     :birthday
#         datetime :last_logged_in
#         time     :last_visited_at
#         hash :company do
#           string :name
#         end
#         array :emails, each: :string
#         array :social_accounts, each: :hash do
#           string :name
#           symbol :type
#         end
#       end
#     end
#   end
#
# The defined caster will have #cast method which accepts hash
# Use it to cast hash:
#   ContactCaster.new.cast({
#     contact: {
#       name: "John Smith",
#       age: "22",
#       weight: "65.5",
#       birthday: "2014-02-02",
#       last_logged_in: "2014-02-02 10:10:00",
#       last_visited_at: "2014-02-02 10:10:00",
#       company: {
#         name: "MyCo",
#       },
#       emails: [ "test@example.com", "test2@example.com" ],
#       social_accounts: [
#         {
#           name: "john_smith",
#           type: 'twitter',
#         },
#         {
#           name: "John",
#           type: :facebook,
#         },
#       ]
#     }
#   })
#
#   The output will be casted hash:
#   {
#     contact: {
#       name: "John Smith",
#       age: 22,
#       weight: 65.5,
#       birthday: Date.parse("2014-02-02"),
#       last_logged_in: DateTime.parse("2014-02-02 10:10:00"),
#       last_visited_at: Time.parse("2014-02-02 10:10:00"),
#       company: {
#         name: "MyCo",
#       },
#       emails: [ "test@example.com", "test2@example.com" ],
#       social_accounts: [
#         {
#           name: "john_smith",
#           type: :twitter,
#         },
#         {
#           name: "John",
#           type: :facebook,
#         },
#       ]
#     }
#   }
module HashCast::Caster
  extend HashCast::Concern

  module ClassMethods
    ALLOWED_OPTIONS = [:string, :symbol]

    # Defines casting rules
    # @example
    #  attributes do
    #    string   :first_name
    #    string   :last_name
    #    integer  :age, optional: true
    #  end
    def attributes(&block)
      raise ArgumentError, "You should provide block" unless block_given?

      attributes = HashCast::AttributesParser.parse(&block)
      self.instance_variable_set(:@attributes, attributes)
    end

    # Performs casting
    # @param hash [Hash] hash for casting
    # @param options [Hash] options, input_keys: :string, output_key: :symbol
    def cast(hash, options = {})
      check_attributes_defined!
      check_hash_given!(hash)
      check_options!(options)
      options = set_default_options(options)

      attributes_caster = HashCast::AttributesCaster.new(instance_variable_get(:@attributes), options)
      attributes_caster.cast(hash)
    end

    private

    def check_attributes_defined!
      unless instance_variable_defined?(:@attributes)
        raise HashCast::Errors::ArgumentError, "Attributes block should be defined"
      end
    end

    def check_options!(options)
      unless options.is_a?(Hash)
        raise HashCast::Errors::ArgumentError, "Options should be a hash"
      end
      if options[:input_keys] && !ALLOWED_OPTIONS.include?(options[:input_keys])
        raise HashCast::Errors::ArgumentError, "input_keys should be :string or :symbol"
      end
      if options[:output_keys] && !ALLOWED_OPTIONS.include?(options[:output_keys])
        raise HashCast::Errors::ArgumentError, "output_keys should be :string or :symbol"
      end
    end

    def check_hash_given!(hash)
      unless hash.is_a?(Hash)
        raise HashCast::Errors::ArgumentError, "Hash should be given"
      end
    end

    def set_default_options(options)
      options[:input_keys]  ||= HashCast.config.input_keys
      options[:output_keys] ||= HashCast.config.output_keys
      options
    end
  end
end
