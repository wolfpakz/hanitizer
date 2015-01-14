class Hanitizer::Generator::Zip
  def generate(row)
    Faker::Address.zip
  end
end