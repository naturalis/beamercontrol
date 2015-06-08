def check_beamer_name(beamer)
  unless File.file? "./beamers.d/#{beamer}.yaml"
    puts "Beamer config #{beamer}.yaml does not compute. Run ./beamer.rb -h for options"
    exit 1
  end
end

def check_beamer_options(beamer,command)
  config = YAML.load_file("beamers.d/#{beamer}.yaml")
  unless config['commands'].include? command
    puts "Option #{command}.yaml does not compute. Run ./beamer.rb -o -b [beamer] for beamer options"
    exit 1
  end
end

def check_ip(ip)
  unless ip =~ Resolv::IPv4::Regex
    puts "#{ip} is not an valid ip address"
    exit 1
  end
end

def check_port(port)
  if port.to_s.match(/^\d+$/).nil?
    puts "#{port} is not a Integer"
    exit 1
  end
end
