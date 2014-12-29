module Hanitizer
  class Sanitizer
    attr_accessor :collection, :definition

    def initialize(collection, &block)
      raise ArgumentError, 'Block required to define a Sanitizer' unless block_given?

      @collection = collection
      @definition = block
    end

    def sanitize(row)
    end
  end
end