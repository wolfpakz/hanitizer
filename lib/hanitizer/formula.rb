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

    def sanitize(name, &block)
      name = name.to_s
      @sanitizers[name] ||= []
      @sanitizers[name] << Sanitizer.new(&block)
    end

    def truncate(name)
      name = name.to_s
      truncations << name unless truncations.include?(name)
    end
  end
end
