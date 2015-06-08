require 'net/telnet'
require 'resolv'
require 'yaml'

define_method(:sendtelnet) do | beamer:, host:,port:, command:, extron_port: '', testmode: false|

  result = String.new

  config = YAML.load_file("beamers.d/#{beamer}.yaml")

  if testmode
    puts "Sending to #{host}:#{port} on extronport: #{extron_port}"
    puts "Sending command: #{command}"
    puts "Telnet Command to send: #{config['commands'][command]['cmd'].sub('__port__',extron_port.to_s).dump}"
    exit
  end

  #resp = String.new
  begin
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

    #telnet.cmd('exit')

  rescue Timeout::Error
    puts 'ERROR: Timout error'
    telnet.close
    exit 2
  end
  #puts resp
  result
end
