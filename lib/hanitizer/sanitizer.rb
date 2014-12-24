module Hanitizer
  class Sanitizer
    attr_accessor :name, :definition

    def initialize(name, &block)
      raise ArgumentError, 'Block required to define a Sanitizer' unless block_given?

      @name = name
      @definition = block
    end
  end
end