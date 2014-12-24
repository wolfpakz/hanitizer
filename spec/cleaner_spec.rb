require 'hanitizer/cleaner'

module Hanitizer
  RSpec.describe Cleaner do

    it 'has formulae'

    describe '.new' do
      context 'with one formula name' do
        it 'adds to the list of formulae'
      end

      context 'with multiple names' do
        it 'adds all names to the list of formulae'
      end
    end


    describe '#clean' do
      # def clean
      #   formulae.each do |formula|
      #     apply formula
      #   end
      # end

      # cleaner.clean self
      it 'applies all formulae'

      context 'without a repository' do
        # cleaner.clean
        it 'raises an ArgumentError'
      end
    end


    describe '#apply' do
      # def apply(formula)
      #   formula.truncations.each do |name|
      #     repository.truncate name
      #   end
      #
      #   formula.sanitizers.each do |sanitizer|
      #     repository.update_each(sanitizer.collection_name) do |row|
      #       sanitizer.sanitize row
      #     end
      #   end
      # end

      it 'applies all truncations'
      it 'applies all sanitizers'
    end
  end
end
