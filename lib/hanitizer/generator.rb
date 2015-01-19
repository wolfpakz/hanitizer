require 'inflector'
require_relative 'errors'

module Hanitizer
  module Generator
    def self.exists?(name)
      name = name.to_s
      Generator.const_defined? Inflector.pascalize name
    end

    def self.generate(name, *args)
      klass_for(name).generate(*args)
    end

    def self.klass_for(name)
      name = name.to_s
      klass = 'Hanitizer::Generator::%s' % [Inflector.pascalize(name)]
      Inflector.constantize(klass)
    end

    class Context
      attr_reader :row

      def initialize(row)
        @row = row
      end

      def execute(&block)
        args = []
        args << row if block.arity > 0
        instance_exec(*args, &block)
        row
      end

      def method_missing(name, *args)
        if Generator.exists?(name)
          apply_generator(name, *args)
        else
          raise Hanitizer::MissingGeneratorError, "undefined generator #{name}"
        end
      end

      def apply_generator(name, *args)
        field = args.shift
        klass = Generator.klass_for(name)
        generator = klass.new
        arguments = [row] + Array(args)
        row[field] = generator.generate(*arguments)
        true
      end
    end
  end
end

require_relative 'generator/first_name'
require_relative 'generator/last_name'
require_relative 'generator/email'
require_relative 'generator/address1'
require_relative 'generator/address2'
require_relative 'generator/city'
require_relative 'generator/state'
require_relative 'generator/zip'
require_relative 'generator/country'
require_relative 'generator/nullify'
