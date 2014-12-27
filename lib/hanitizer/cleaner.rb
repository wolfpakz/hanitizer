module Hanitizer
  class Cleaner
    attr_reader :formulas

    def initialize(*formulas)
      @formulas = formulas
    end

    def clean(repository)
    end
  end
end