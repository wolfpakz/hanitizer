require 'hanitizer/formula'

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

    def sanitize_row(row, sanitizers)
      sanitizers.reduce(row) do |working_row, sanitizer|
        sanitizer.sanitize(working_row)
      end
    end

    def apply(formula, repository)
      formula.truncations.each do |name|
        repository.truncate name
      end

      formula.sanitize_targets.each do |collection|
        sanitizers = formula.sanitizers[collection]
        repository.update_each(collection) { |row| sanitize_row row, sanitizers }
      end
    end
  end
end