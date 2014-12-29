require 'hanitizer/version'
require 'hanitizer/adapter'
require 'hanitizer/adapter/mysql'
require 'hanitizer/formula'
require 'uri'

module Hanitizer
  @@formulas = {} unless defined? @@formulas

  def self.adapter_class(name)
    string = name.to_s
    downcased = string.downcase
    capped = downcased.capitalize

    Adapter.const_get capped
  end

  def self.connect(url)
    uri = URI.parse(url)
    klass = adapter_class uri.scheme

    adapter = klass.new
    adapter.connect url
    adapter
  end

  def self.formula(name, &block)
    raise ArgumentError, 'Block required to define a Formula, but none given.' unless block_given?
    @@formulas[name] = Formula.new(name)
    @@formulas[name].instance_eval(&block)
    @@formulas[name]
  end

  def self.formulas
    @@formulas
  end
end
