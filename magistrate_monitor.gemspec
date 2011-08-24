Gem::Specification.new do |s|
  s.name = "magistrate_monitor"
  s.version = "0.2.3"
  
  s.summary = "The user frontend to monitoring and managing the magistrate gem"
  s.description = "Receives checkins from the magistrate gem and sends back commands"

  s.author    = 'Drew Blas'
  s.email     = 'drew.blas@gmail.com'
  
  #  s.rubygems_version = %q{1.3.6}

  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  
  s.files = Dir["**/*"].select { |d| d =~ %r{^(bin|db|lib)} }
  s.files += %w[
    Gemfile
    LICENSE.txt
    README.md
    Rakefile
    config.ru
    magistrate_monitor.gemspec
  ]
  
  s.homepage = 'http://github.com/drewblas/magistrate_monitor'
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]


  s.test_files = Dir["**/*"].select { |d| d =~ %r{^(spec)} }
  
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', "~> 2.6.0")
  s.add_development_dependency('rcov', '>= 0')
  s.add_development_dependency('sqlite3')
  s.add_development_dependency('mongrel')
  s.add_development_dependency('rack-test')
  s.add_runtime_dependency('sinatra', '~> 1.2.6')
  s.add_runtime_dependency('activerecord', '>= 3.0')
  s.add_runtime_dependency('activesupport', '>= 3.0')
  s.add_runtime_dependency('awesome_print', '~> 0.4.0')
end
