DIAGNOSTIC_LOGGER = defined?(Rails) ? Rails.logger : require('logger') && Logger.new($stdout)

require 'lib/server'