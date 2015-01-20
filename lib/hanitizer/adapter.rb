require_relative 'cleaner'

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

    def connect(url)
      raise '%s has not implemented method connect(url)' % [self.class]
    end

    def collection_entries(collection)
      raise '%s has not implemented method collection_entries(collection)' % [self.class]
    end

    def truncate(name)
      raise '%s has not implemented method truncate(name)' % [self.class]
    end

    def update(collection_name, id, attributes)
      raise '%s has not implemented method update(collection, id, attributes)' % [self.class]
    end
  end
end
