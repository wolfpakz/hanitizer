class Hanitizer::Generator::Email
  def generate(row)
    Faker::Internet.safe_email
  end
end