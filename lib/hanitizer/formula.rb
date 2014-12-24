require_relative 'sanitizer'

module Hanitizer
  class Formula
    attr_accessor :name

    def initialize(name)
      @name = name
      @sanitizers = []
    end

    def sanitize(name, &block)
      @sanitizers << Sanitizer.new(name, &block)
    end

    def sanitizers
      @sanitizers
    end

    def truncate(name)
      truncations << name unless truncations.include?(name)
    end

    def truncations
      @truncations ||= []
    end
  end
end
