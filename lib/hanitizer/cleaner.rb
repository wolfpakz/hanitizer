module Hanitizer
  class Cleaner
    attr_reader :formulas

    def initialize(*formulas)
      @formulas = formulas
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

      formula.sanitize_targets.each do |collection|
        sanitizer = formula.sanitizers[collection]

        repository.update_each(collection, sanitizer.primary_key) do |row|
          sanitizer.sanitize(row)
        end
      end
    end
  end
end