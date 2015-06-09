require 'sinatra'
require 'json'
require 'net/telnet'
require 'resolv'
Dir["#{File.join(File.expand_path(File.dirname(__FILE__)).split('/')[0..-1])}/../lib/*.rb"].each { |l| require l}

get '/' do
  erb :index
end

get '/types/' do
  content_type :json
  list.to_json
end

get '/types/:type' do
  content_type :json
  beameroptions(params[:type]).to_json
end

post '/command/:cmd' do
  content_type :json
  request.body.rewind
  begin
    data = JSON.parse(request.body.read)
    sendtelnet(
       host: data['host'],
       port: data['port'],
       beamer: data['beamer'] ,
       command: params[:cmd],
       extron_port: data['extron_port']).to_json
  rescue
    {:error => 'no valid json'}.to_json
  end
end
