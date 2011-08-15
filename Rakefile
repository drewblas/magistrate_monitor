require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "magistrate_monitor #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# Thanks to: https://github.com/bmizerany/sinatra-activerecord/blob/master/lib/sinatra/activerecord/rake.rb
namespace :db do
  desc "migrate your database"
  task :migrate do
    require 'active_record'
    require 'active_support/all'
    require 'fileutils'
    require 'erb'
    
    env = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'

    file = File.join('config', 'database.yml')
    database_options = YAML::load(ERB.new(IO.read(file)).result).with_indifferent_access[env]
    
    ActiveRecord::Base.establish_connection(database_options)
    
    ActiveRecord::Migrator.migrate(
      'db/migrate', 
      ENV["VERSION"] ? ENV["VERSION"].to_i : nil
    )
  end

  desc "create an ActiveRecord migration in ./db/migrate"
  task :create_migration do
    name = ENV['NAME']
    abort("no NAME specified. use `rake db:create_migration NAME=create_users`") if !name

    migrations_dir = File.join("db", "migrate")
    version = ENV["VERSION"] || Time.now.utc.strftime("%Y%m%d%H%M%S") 
    filename = "#{version}_#{name}.rb"
    migration_name = name.gsub(/_(.)/) { $1.upcase }.gsub(/^(.)/) { $1.upcase }

    FileUtils.mkdir_p(migrations_dir)

    open(File.join(migrations_dir, filename), 'w') do |f|
      f << (<<-EOS).gsub("      ", "")
      class #{migration_name} < ActiveRecord::Migration
        def self.up
        end

        def self.down
        end
      end
      EOS
    end
  end
end
