class Hanitizer::Generator::UsPhone
  def generate(row)
    Faker::PhoneNumber.phone_number
  end
end
