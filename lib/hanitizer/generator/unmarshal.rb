class Hanitizer::Generator::Unmarshal
  def generate(row, original_value, &block)
    obj = Marshal.load original_value
    Marshal.dump block.call(obj)
  end
end
