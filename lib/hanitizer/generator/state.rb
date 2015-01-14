class Hanitizer::Generator::State
  def generate(row)
    Faker::Address.state
  end
end