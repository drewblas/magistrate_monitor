require 'sinatra/base'
require 'sinatra-activerecord'

require 'supervisor'

module MagistrateMonitor
  class Server < Sinatra::Base
    dir = File.dirname(File.expand_path(__FILE__))

    set :views,  "#{dir}/views"
    set :public, "#{dir}/public"
    set :static, true
    
    set :basic_auth_credentials, lambda {
      config_file = File.join('config', 'magistrate.yml')
      if File.exist?( config_file )
        config = File.open(config_file) { |file| YAML.load(file) }
        if config['http_username'] && config['http_password']
          [config['http_username'], config['http_password']]
        end
      end
    }
    
    if basic_auth_credentials
      use Rack::Auth::Basic do |username, password|
        [username, password] == basic_auth_credentials
      end
    end
    
    get '/', :provides => 'html' do
      @supervisors = Supervisor.order('name ASC').all
      normalize_status_data!
      
      erb :index
    end
    
    get '/supervisors/:name' do
      @supervisor = Supervisor.find_by_name params[:name]
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

    post '/set/:supervisor_name/:worker_name/:action' do
      @supervisor = Supervisor.find_or_create_by_name params[:supervisor_name]
      
      @supervisor.set_target_state!(params[:action], params[:worker_name])
      redirect url('/')
    end
    
    helpers do
      def url_for(path)
        root = request.env['SCRIPT_NAME'].chomp('/')
        "#{root}/#{path}"
      end
      
      def url_for_worker(supervisor, name, action)
        url("/set/#{supervisor.name}/#{name}/#{action}")
      end

      def normalize_status_data!
        @supervisors.each do |supervisor|
          supervisor.normalize_status_data!
        end
      end
    end
  end
end