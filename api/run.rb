require 'sinatra'
require 'json'
require 'net/telnet'
require 'resolv'
Dir["#{File.join(File.expand_path(File.dirname(__FILE__)).split('/')[0..-1])}/../lib/*.rb"].each { |l| require l}

require './lib/telnet.rb'


get '/' do
  erb :index
end

get '/types/' do
  content_type :json
  list = Array.new
  Dir["./beamers.d/*.yaml"].each do |f|
    b = YAML.load_file(f)
    list << b['name']
  end
  {:types => list}.to_json
end

get '/types/:type' do
  content_type :json
  options = Array.new
  begin
    YAML.load_file("./beamers.d/#{params[:type]}.yaml")['commands'].each do |k,v|
      options << k
    end
    { :options => options }.to_json
  rescue
    "Could not load beamertype: #{params[:type]}".to_json
  end
end

post '/command/:cmd' do
  request.body.rewind
  data = JSON.parse(request.body.read)
  puts 'here'
  request.body.read
  puts data['host']
  puts data['port']
  puts data['beamer']
  puts '-------------'
  cmd = sendtelnet(
      host: data['host'],
      port: data['port'],
      beamer: data['beamer'] ,
      command: 'status',
      extron_port: 1,
      testmode: false)
  cmd['result']

  # begin
  #   data = JSON.parse(request.body.read)
  #   #puts data
  #   sendtelnet(
  #      host: data['host'],
  #      port: data['port'],
  #      beamer: data['beamer'] ,
  #      command: 'status',
  #      extron_port: 1)
  #   # #{:result => cmd}.to_json
  #   #puts cmd
  # rescue
  #   {:error => 'no valid json'}.to_json
  # end
end
