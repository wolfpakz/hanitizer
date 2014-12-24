class RepositoryAdapter
  # def connect(url)
  #   uri = URI.parse(url)
  #   scheme = uri.scheme
  #
  #   klass = Kernel.constants "Hanitizer::RepositoryAdapter::#{scheme.ucfirst}"
  #   adapter = klass.new uri.host, uri.user, uri.password
  #   adapter.use_database uri.path
  #   adapter
  # end
end