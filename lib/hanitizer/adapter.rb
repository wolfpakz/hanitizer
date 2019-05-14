require_relative 'cleaner'

module Hanitizer
  class Adapter
    def sanitize_with(*formula_names)
      formulas = if formula_names.empty?
                   []
                 else
                   formula_names.map do |name|
                     formula = Hanitizer.formulas[name]
                     raise MissingFormulaError, name unless formula
                     formula
                   end
                 end
      cleaner = Cleaner.new(*formulas)
      cleaner.clean(self)
    end

    def update_each(collection_name, primary_key, &block)
      collection_entries(collection_name).each do |entry|
        symbolized_key_entry = symbolize_keys(entry)
        updated_entry = yield Hash.new.merge(symbolized_key_entry)

        update(collection_name, primary_key, symbolized_key_entry[primary_key], updated_entry) unless updated_entry.eql?(symbolized_key_entry)
      end
    end
    
    def symbolize_keys(entries)
      hash = {}
      entries.map do |k, v|
        hash[k.to_sym] = v
      end
      hash
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
