module Hanitizer
  class Cleaner
    attr_reader :formulas

    def initialize(*formula_names)
      @formulas = []
      @formulas = formula_names.map { |name| Hanitizer.formulas[name] } unless formula_names.empty?
    end

    def clean(repository)
      formulas.each do |formula|
        apply formula, repository
      end
    end

    def apply(formula, repository)
      formula.truncations.each do |name|
        repository.truncate name
      end

      formula.sanitizers.each do |sanitizer|
        repository.update_each(sanitizer.collection) do |row|
          sanitizer.sanitize row
        end
      end
    end
  end
end