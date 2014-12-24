require_relative '../adapter'
require 'mysql2'

module Hanitizer
  class Adapter::Mysql < Adapter
    attr_reader :client

    def connect(connection_string)
      uri = URI.parse(connection_string)
      host, user, password = uri.host, uri.user, uri.password

      @client = ::Mysql2::Client.new :host => host, :username => user, :password => password
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

    def update_each(collection_name, &block)
    end
  end
end