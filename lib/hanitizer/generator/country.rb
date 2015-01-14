class Hanitizer::Generator::Country
  def generate(row)
    Faker::Address.country
  end
end