require 'sinatra/base'
require 'magistrate_monitor/sinatra-activerecord'

require 'magistrate_monitor/supervisor'
require 'awesome_print'

module MagistrateMonitor
  class Server < Sinatra::Base
    dir = File.dirname(File.expand_path(__FILE__))

    set :views,  "#{dir}/views"
    set :public, "#{dir}/public"
    set :static, true
    
    set :basic_auth_credentials, lambda {
      result = nil
      
      config_file = File.join('config', 'magistrate.yml')
      if File.exist?( config_file )
        config = YAML::load( File.open(config_file) )
        if config['http_username'] && config['http_password']
          result = [config['http_username'], config['http_password']]
        end
      end
      
      result
    }
    
    if basic_auth_credentials && ENV['RACK_ENV'] != 'test'
      use Rack::Auth::Basic do |username, password|
        [username, password] == basic_auth_credentials
      end
    end
    
    get '/' do
      @supervisors = Supervisor.order('name ASC').all
      normalize_status_data!
      
      erb :index
    end
    
    get '/supervisors/:name' do
      @supervisor = Supervisor.find_by_name! params[:name]
      erb :show
    end
    
    post '/supervisors/:name/delete' do
      @supervisor = Supervisor.find_by_name! params[:name]
      @supervisor.destroy
      redirect url('/')
    end
    
    # Responds with the latest databag instructions for the supervisor
    get '/api/status/:name' do
      @supervisor = Supervisor.find_or_create_by_name params[:name]
      
      content_type :json
      ActiveSupport::JSON.encode( @supervisor.databag || {} )
    end
    
    # Saves the status update to the db
    post '/api/status/:name' do
      @supervisor = Supervisor.find_or_create_by_name params[:name]
      
      status = ActiveSupport::JSON.decode( params[:status] )
      
      @supervisor.update_attributes :last_checkin_at => Time.now, :status => status
      
      content_type :json
      ActiveSupport::JSON.encode( {:status => 'Ok'} )
    end

    post '/supervisors/:supervisor_name/workers/:worker_name/set_target_state/:action' do
      @supervisor = Supervisor.find_or_create_by_name params[:supervisor_name]
      
      @supervisor.set_target_state!(params[:action], params[:worker_name])
      redirect url('/')
    end
    
    helpers do
      # def url_for(path)
      #   root = request.env['SCRIPT_NAME'].chomp('/')
      #   "#{root}/#{path}"
      # end
      
      def target_state_url_for_worker(supervisor, name, action)
        url("/supervisors/#{supervisor.name}/workers/#{name}/set_target_state/#{action}")
      end

      def normalize_status_data!
        @supervisors.each do |supervisor|
          supervisor.normalize_status_data!
        end
      end
    end
  end
end
