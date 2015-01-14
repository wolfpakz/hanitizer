class Hanitizer::Generator::City
  def generate(row)
    Faker::Address.city
  end
end