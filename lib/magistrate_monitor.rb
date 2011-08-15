DIAGNOSTIC_LOGGER = defined?(Rails) ? Rails.logger : require('logger') && Logger.new($stdout)

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'server'