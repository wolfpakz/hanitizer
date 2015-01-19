class Hanitizer::Generator::Customize
  def generate(row, &block)
    raise ArgumentError, 'Block expected but none given' unless block_given?
    block.call(row)
  end
end