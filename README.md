# Hanitizer

Production data ends up in our development environments for a variety of reasons. Developers handling production data introduces security and privacy issues. By sanitizing the data, we can reduce those risks.

Write formulae for sanitizing your SQL database, using a simple DSL, that offers fake data generation, table truncation, and more. 
 
## Installation

Add this line to your application's Gemfile:

    gem 'hanitizer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hanitizer

## Usage Examples

### Define hanitizer formula(s): 

    Hanitizer.formula(:transactions) do
      # Empty these table(s)
      truncate :batches, :entries, :headers, :files, :transactions
    end
    
### Connect to a database

    repository = Hanitizer.connect 'postgres://user:password@host/database_name/'

### Run your formula(s)

    repository.sanitize_with :transactions, :members, :users

## Formula Examples

### Generate fake data

    Hanitizer.formula(:members) do
    
      # Sanitize addresses table
      sanitize :addresses do
      
        # Generate fake address information
        address1 :address1
        address2 :address2
        city :city
        state :state
        zip :zip
        country :country
        
      end

      # Sanitize members table
      sanitize :members do
        # Generate fake email addresses
        email :email
      end
      
    end

### Set columns to NULL
      
    Hanitizer.formula(:users) do
    
      # Sanitize users table
      sanitize :users do
      
        # Clear IP addresses
        nullify :current_sign_in_ip, :last_sign_in_ip
    
        # Remove lock info
        nullify :unlock_token, :locked_at
    
        # Remove password reset info
        nullify :reset_password_token, :reset_password_sent_at
        
      end
      
    end
    
### Use blocks to generate custom values
 
    Hanitizer.formula(:accounts) do
      sanitize :bank_accounts do
        
        # Generate fake first/last
        first_name :first_name
        last_name  :last_name
        
        # Use first/last to customize email address
        customize :email do |row|
          "#{row[:first_name][0]}#{row[:last_name]}@example.com"
        end

        customize :routing_number {
          (1..9).to_a.map { rand(9).to_s }.join # Generate 9 digit numbers
        }
        
      end
    end
            
            
### Work with Marshalled values 
    
    Hanitizer.formula(:marshalling) do
      sanitize :discounts do
      
        # Use Marshal to store ruby objects
        marshal :properties do
           {:foo => 'bar'}
        end
        
      end
      
      sanitize :transactions do
        
        # Use Unmarshal to read / modify stored ruby objects from the 'response' column
        unmarshal :response do |response|
        
          # Modify the response object
          response.value = %w(1 2 3 4).shuffle.join
          
          # Block return value is Marshaled and stored in the column
          response
        end
        
      end
    end
    
### Update Devise password

    Hanitizer.formula(:passwords) do
      sanitize :users do
      
        # Generate fake email addresses
        email :email
        
        # Update Devise encrypted password
        customize :encrypted_password do
          User.new(:password => SecureRandom.hex).encrypted_password
        end
        
      end
      
    end
    
### Create a custom generator

    class Hanitizer::Generator::UkPhone
      def self.generate
        "(020) 7890 4321"
      end
    end

### Use a custom generator

    Hanitizer.config do
      sanitize :users do
        uk_phone :phone
      end
    end


## Contributing

1. Fork it ( http://github.com/<my-github-username>/hanitizer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
