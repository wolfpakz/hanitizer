module Hanitizer
  class Adapter
    def sanitize_with(*formulas)
      cleaner = Cleaner.new(*formulas)
      cleaner.clean(self)
    end

    def update_each(collection_name, &block)
      collection_entries(collection_name).each do |entry|
        updated_entry = yield Hash.new.merge(entry)
        update(collection_name, entry['id'], updated_entry) unless updated_entry.eql?(entry)
      end
    end
  end
end
