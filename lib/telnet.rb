require 'net/telnet'
require 'resolv'
require 'yaml'
#require './lib/checks.rb'
#puts "#{File.join(File.expand_path(File.dirname(__FILE__)).split('/')[0..-1])}/../lib/*.rb"
#Dir["#{File.join(File.expand_path(File.dirname(__FILE__)).split('/')[0..-1])}/../lib/*.rb"].each { |l| require l}


define_method(:sendtelnet) do | beamer:, host:, port:, command:, extron_port: '', testmode: false|

  result = String.new
  # checks = {
  #   'check_beamer_name' => beamer,
  #   'check_beamer_options' => [beamer,command],
  #   'check_ip' => host,
  #   'check_port' => port
  # }


  # checks.each do |k,v|
  #   next if send(k,v) == 'ok'
  #   result = send(k,v)
  #   break
  # end




  if !result.empty?
    #just a catch for errors in checks
  elsif testmode

    config = YAML.load_file("beamers.d/#{beamer}.yaml")
    result = "Sending to #{host}:#{port} on extronport: #{extron_port}\n"
    result += "Sending command: #{command}\n"
    result += "Telnet Command to send: #{config['commands'][command]['cmd'].sub('__port__',extron_port.to_s).dump}"

  else

    begin
      config = YAML.load_file("beamers.d/#{beamer}.yaml")
      telnet = Net::Telnet::new( 'Host' => host, 'Timeout' => 5 , 'Port' => port)
      telnet.waitfor('Match' => /\d{2}:\d{2}:\d{2}$\s/ )
      telnet.cmd( 'String' => config['commands'][command]['cmd'].sub('__port__',extron_port.to_s), 'Match' => /\n/) { |c|
        found = false
        #puts "return #{c.dump}"
        config['commands'][command]['returns'].each do |k,v|
          unless c.match(/#{v['regex']}/).nil?
            result = v['message'].sub('__return__',c)
            #telnet.close
            found = true
            break
          end
        end
        result = "ERROR: cannot find #{c}. Please reconfigure your config yaml" unless found

      }
      telnet.close
    rescue Timeout::Error
      result = 'ERROR: Timout error'
      telnet.close
    end

  end

  {"result" => result}

end
