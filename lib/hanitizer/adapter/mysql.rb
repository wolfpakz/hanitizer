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
      client.query('SELECT * FROM %s' % client.escape(collection_name))
    end

    def truncate(*collection_names)
      collection_names = Array(collection_names)
      escaped_names = collection_names.map { |name| client.escape name }

      escaped_names.each do |name|
        client.query('TRUNCATE %s' % name)
      end
    end

    def update(collection, id, attributes)
      attributes.delete('id') if attributes.key?('id')

      unless attributes.empty?
        mapped_attributes = attributes.map do |pair|
          key,value = pair
          "%s = '%s'" % [key, client.escape(value)]
        end

        sql = 'UPDATE %s SET %s WHERE id = %d' % [client.escape(collection), mapped_attributes.join(', '), id]
        client.query(sql)
      end
    end


  end
end