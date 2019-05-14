require_relative 'sanitizer'

module Hanitizer
  class Formula
    attr_accessor :name
    attr_reader :sanitizers, :truncations

    def initialize(name)
      @name = name
      @sanitizers  = {}
      @truncations = []
    end

    def sanitize(name, options={primary_key: :id}, &block)
      name = name.to_s
      raise ArgumentError, "Duplicate sanitizer for collection '#{name}'" if @sanitizers.has_key?(name)

      @sanitizers[name] = Sanitizer.new(options, &block)
    end

    def sanitize_targets
      @sanitizers.keys
    end

    def truncate(name)
      name = name.to_s
      truncations << name unless truncations.include?(name)
    end
  end
end
