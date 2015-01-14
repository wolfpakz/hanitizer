require 'faker'

class Hanitizer::Generator::FirstName
  def generate(row)
    Faker::Name.first_name
  end
end
