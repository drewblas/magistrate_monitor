Gem::Specification.new do |s|
  s.name = "magistrate_monitor"
  s.version = "0.1.0"
  
  s.summary = "The user frontend to monitoring and managing the magistrate gem"
  s.description = "Receives checkins from the magistrate gem and sends back commands"

  s.author    = 'Drew Blas'
  s.email     = 'drew.blas@gmail.com'
  s.date = %q{2011-08-10}
  
  #  s.rubygems_version = %q{1.3.6}

  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "lib/magistrate_monitor.rb",
    "lib/server.rb",
    "spec/spec_helper.rb"
  ]
  
  s.homepage = 'http://github.com/drewblas/magistrate_monitor'
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]


  s.test_files = [
    "spec/spec_helper.rb"
  ]

  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', "~> 2.6.0")
  s.add_development_dependency('rcov', '>= 0')
  s.add_development_dependency('sqlite3')
  s.add_runtime_dependency('sinatra', '~> 1.2.6')
  s.add_runtime_dependency('activerecord', '>= 3.0')
  s.add_runtime_dependency('activesupport', '>= 3.0')
end
