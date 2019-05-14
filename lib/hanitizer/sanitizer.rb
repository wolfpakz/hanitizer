require_relative 'generator'

module Hanitizer
  class Sanitizer
    attr_accessor :definition
    attr_reader :primary_key

    def initialize(options={primary_key: :id}, &block)
      raise ArgumentError, 'Primary key required to define a Sanitizer' unless primary_key_defined?(options)
      raise ArgumentError, 'Block required to define a Sanitizer' unless block_given?

      @primary_key = options[:primary_key]
      @definition = block
    end

    def sanitize(row)
      context = Generator::Context.new row
      context.execute(&definition)
    end

    private

    def primary_key_defined?(primary_key: nil)
      primary_key.nil? ? false : true
    end
  end
end