module Hanitizer
  class Sanitizer
    attr_accessor :definition

    def initialize(&block)
      raise ArgumentError, 'Block required to define a Sanitizer' unless block_given?

      @definition = block
    end

    def sanitize(row)
    end
  end
end