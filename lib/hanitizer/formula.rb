require_relative 'sanitizer'

module Hanitizer
  class Formula
    def sanitize(name)
      @sanitizers << Sanitizer.new(name)
    end

    def sanitizers
      @sanitizers ||= []
    end

    def truncate(name)
      truncations << name unless truncations.include?(name)
    end

    def truncations
      @truncations ||= []
    end
  end
end
