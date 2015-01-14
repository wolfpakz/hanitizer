require_relative 'generator'

module Hanitizer
  class Sanitizer
    attr_accessor :definition

    def initialize(&block)
      raise ArgumentError, 'Block required to define a Sanitizer' unless block_given?

      @definition = block
    end

    def sanitize(row)
      context = Generator::Context.new row
      context.execute(&definition)
    end
  end
end