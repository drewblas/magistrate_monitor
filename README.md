# Magistrate Monitor

MagistrateMonitor is a frontend to the Magistrate gem that allows the gem to check in with the status of its workers and to receive commands from
the frontend user (such as enable/disable and start/stop workers)

## Installation

### Standalone Sinatra
MagistrateMonitor will run as a standalone Sinatra app.  It will use ActiveRecord for the DB connection.  Create a config/database.yml file
with your connection details.  Then run rake db:migrate as normal.  Then you can start the app with rackup or your other preferred method.

### Mounting in Rails 3.x
MagistrateMonitor will mount in a Rails 3.x app very easily.  

1. Add the gem to your Gemfile: `gem 'magistrate_monitor`
2. Copy the migrations to your main migration folder and run them.
3. Then add this to your routes.rb:

    mount MagistrateMonitor::Server => '/magistrate'
    
4. Add a config/magistrate.yml file if you want to have authentication (see the magistrate gem's example_config.yml)

### Mounting the application in rails 2.3.*

Create a new folder in app called metal. Add the file magistrate_monitor_web.rb with:
  
    require 'magistrate_monitor'
    class MagistrateMonitorWeb
      @app = Rack::Builder.new {
        map "/magistrate_monitor" do
          run MagistrateMonitor::Server.new
        end
      }.to_app

      def self.call(env)
        @app.call(env)
      end
    end
  
This will route all requests to /magistrate_monitor to the magistrate_monitor rack app

## Contributing to magistrate_monitor
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Drew Blas. See LICENSE.txt for further details.

## Acknowledgements

Thanks to Matthew Deiter's healthy gem for the example of building this as a rack app (since I couldn't get 3.1 mountable engines to work)