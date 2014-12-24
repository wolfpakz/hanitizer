require "hanitizer/version"

module Hanitizer
  @@formulae = {} unless defined? @@formulae

  def self.formula(name, &block)
    raise ArgumentError, 'Block required to define a Formula, but none given.' unless block_given?
    @@formulae[name] = Formula.new(name)
    @@formulae[name].instance_eval(&block)
    @@formulae[name]
  end

  def self.formulae
    @@formulae
  end
end
