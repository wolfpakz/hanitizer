require_relative '../adapter'
require 'mysql2'

module Hanitizer
  class Adapter::Mysql < Adapter
    attr_reader :client

    def connect(connection_string)
      uri = URI.parse(connection_string)
      host, user, password, path = uri.host, uri.user, uri.password, uri.path
      database = path.gsub('/', '')

      @client = ::Mysql2::Client.new :host => host, :username => user, :password => password, :database => database
    end

    def collection_entries(collection_name)
      client.query('SELECT * FROM %s' % collection_name)
    end

    def truncate(*collection_names)
      collection_names = Array(collection_names)
      escaped_names = collection_names.map { |name| client.escape name.to_s }

      escaped_names.each do |name|
        client.query('TRUNCATE %s' % name)
      end
    end

    def update(collection, id, attributes)
      attributes.delete('id') if attributes.key?('id')

      unless attributes.empty?
        table = client.escape(collection)
        sql = 'UPDATE %s SET %s WHERE id = %d' % [table, attributes_to_sql(attributes), id]
        client.query sql
      end
    end

    private
    def escape(value)
      return 'NULL' if value.nil?

      case value
        when Fixnum
          value
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