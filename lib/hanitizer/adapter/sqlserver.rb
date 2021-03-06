require_relative '../adapter'
require 'tiny_tds'

module Hanitizer
  class Adapter::Sqlserver < Adapter
    attr_reader :reader
    attr_reader :writer

    def connect(connection_string)
      uri = URI.parse(connection_string)
      host, user, password, path = uri.host, uri.user, uri.password, uri.path
      password = URI.decode(password) if password.include?('%')
      database = path.gsub('/', '')

      @reader = ::TinyTds::Client.new :host => host, :username => user, :database => database, :password => password
      @writer = ::TinyTds::Client.new :host => host, :username => user, :database => database, :password => password
    end

    def collection_entries(collection_name)
      result = reader.execute('SELECT * FROM %s' % collection_name)

      # Support the :count method
      def result.count
        self.affected_rows
      end

      result
    end

    def truncate(*collection_names)
      collection_names = Array(collection_names)
      escaped_names = collection_names.map { |name| writer.escape name.to_s }

      escaped_names.each do |name|
        result = writer.execute('TRUNCATE TABLE %s' % name)
        result.do
      end
    end

    def update(collection, primary_key, id, attributes)
      attributes.delete(primary_key) if attributes.key?(primary_key)

      unless attributes.empty?
        table = writer.escape(collection)
        sql = 'UPDATE %s SET %s WHERE %s = %d' % [table, attributes_to_sql(attributes), primary_key, id]
        result = writer.execute sql
        result.do
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
          "'%s'" % reader.escape(value.to_s)
      end
    end

    def attributes_to_sql(attributes)
      attributes.map do |key,value|
        '%s = %s' % [key, escape(value)]
      end.join(', ')
    end
  end
end