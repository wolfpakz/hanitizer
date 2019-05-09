require_relative '../adapter'
require 'tiny_tds'

module Hanitizer
  class Adapter::SqlServer < Adapter
    attr_reader :client

    def connect(connection_string)
      uri = URI.parse(connection_string)
      host, user, password, path = uri.host, uri.user, uri.password, uri.path
      database = path.gsub('/', '')

      @client = ::TinyTds::Client.new :host => host, :username => user, :database => database, :password => password
    end

    def collection_entries(collection_name)
      result = client.execute('SELECT * FROM %s' % collection_name)

      # Support the :count method
      def result.count
        self.affected_rows
      end

      result
    end

    def truncate(*collection_names)
      collection_names = Array(collection_names)
      escaped_names = collection_names.map { |name| client.escape name.to_s }

      escaped_names.each do |name|
        client.execute('TRUNCATE TABLE %s' % name)
      end
    end

    def update(collection, id, attributes)
      attributes.delete('id') if attributes.key?('id')

      unless attributes.empty?
        table = client.escape(collection)
        sql = 'UPDATE %s SET %s WHERE id = %d' % [table, attributes_to_sql(attributes), id]
        client.execute sql
      end
    end

    private
    def escape(value)
      case value
        when Fixnum
          value
        when nil
          'NULL'
        else
          "'%s'" % client.escape(value.to_s)
      end
    end

    def attributes_to_sql(attributes)
      attributes.map do |key,value|
        '%s = %s' % [key, escape(value)]
      end.join(', ')
    end
  end
end