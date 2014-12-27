module Hanitizer
  class Adapter
    def sanitize_with(*formulas)
      cleaner = Cleaner.new(*formulas)
      cleaner.clean(self)
    end
  end
end
