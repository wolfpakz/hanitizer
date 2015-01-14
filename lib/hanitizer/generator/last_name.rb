class Hanitizer::Generator::LastName
  def generate(row)
    Faker::Name.last_name
  end
end