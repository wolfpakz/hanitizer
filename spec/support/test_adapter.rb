require 'hanitizer/adapter'

module Hanitizer
  class Adapter::Test < Adapter
    def connect(url)
    end

    def collection_entries(collection)
      []
    end

    def truncate(name)
    end

    def update(collection, id, attributes)
    end
  end
end