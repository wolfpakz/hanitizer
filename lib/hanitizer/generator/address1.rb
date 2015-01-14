class Hanitizer::Generator::Address1
  def generate(row)
    Faker::Address.street_address
  end
end