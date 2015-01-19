class Hanitizer::Generator::Marshal
  def generate(row, &block)
    raise ArgumentError, 'Block expected but none given' unless block_given?

    Marshal.dump block.call(row)
  end
end