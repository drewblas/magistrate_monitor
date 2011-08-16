require 'active_record'
require 'active_support/all'
require 'logger'
require 'yaml'
require 'erb'

module Sinatra
  module ActiveRecordHelper
    def database
      options.database
    end
  end

  module ActiveRecordExtension
    def database=(cfg)
      @database = nil
      set :database_options, cfg
      database
    end

    def database
      @database ||= (
        #ActiveRecord::Base.logger ||= activerecord_logger # Having this enabled overrides Rails TODO: Find a way to make it not override Rails
        ActiveRecord::Base.establish_connection(database_options)
        ActiveRecord::Base
      )
    end

  protected
    def self.registered(app)
      app.set :database_options, Hash.new
      app.set :database_extras, Hash.new
      app.set :activerecord_logger, Logger.new(STDOUT)
#      app.database # force connection
      app.helpers ActiveRecordHelper
      
      app.configure do
        if defined?(Rails)
          env = Rails.env
        else
          
          env = ENV['RACK_ENV'] || 'development'
        end
        
        file = File.join('config', 'database.yml')

        app.database = YAML::load(ERB.new(IO.read(file)).result).with_indifferent_access[env]
      end
    end
  end

  register ActiveRecordExtension
end