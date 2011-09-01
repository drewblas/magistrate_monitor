ENV['RACK_ENV'] = 'test'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'magistrate_monitor'


require 'rack/test'

def app
  @app ||= MagistrateMonitor::Server
end

# set test environment
app.set :environment, :test
# set :run, false
# set :raise_errors, true
# set :logging, false

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  config.color_enabled = true
#  config.use_transactional_examples = true

end
