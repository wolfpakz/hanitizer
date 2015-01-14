class Hanitizer::Generator::Address2
  def generate(row)
    Faker::Address.secondary_address
  end
end