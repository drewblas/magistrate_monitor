require 'sinatra/base'
require 'sinatra-activerecord'

require 'supervisor'

module MagistrateMonitor
  class Server < Sinatra::Base
    dir = File.dirname(File.expand_path(__FILE__))

    set :views,  "#{dir}/views"
    set :public, "#{dir}/public"
    set :static, true
        
    get '/', :provides => 'html' do
      @supervisors = Supervisor.order('name ASC').all
      normalize_status_data!
      
      erb :index
    end
    
    get '/supervisors/:name' do
      @supervisor = Supervisor.find_by_name params[:name]
      erb :show
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
    
    # These should not be gets
    # But I'd like to get this working before I go about making the links to POST
    get '/set/:supervisor_name/:worker_name/:action' do
      @supervisor = Supervisor.find_or_create_by_name params[:supervisor_name]
      
      @supervisor.set_target_state!(params[:action], params[:worker_name])
      redirect url_for('')
    end
    
    helpers do
      def url_for(path)
        root = request.env['SCRIPT_NAME'].chomp('/')
        "#{root}/#{path}"
      end
      
      def url_for_worker(supervisor, name, action)
        url_for("set/#{supervisor.name}/#{name}/#{action}")
      end

      def normalize_status_data!
        @supervisors.each do |supervisor|
          supervisor.normalize_status_data!
        end
      end
    end
  end
end