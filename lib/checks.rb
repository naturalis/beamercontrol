def check_beamer_name(beamer)
  unless File.file? "./beamers.d/#{beamer}.yaml"
    "Beamer config #{beamer}.yaml does not compute. Run ./beamer.rb -h for options"
  else
    'ok'
  end
end

def check_beamer_options(opts)
  begin
    config = YAML.load_file("beamers.d/#{opts[0]}.yaml")
    unless config['commands'].include? opts[1]
      "Option #{opts[1]}.yaml does not compute. Run ./beamer.rb -o -b [beamer] for beamer options"
    else
      'ok'
    end
  rescue
    "Cannot load config file. Check beamer name"
  end
end

def check_ip(ip)
  unless ip =~ Resolv::IPv4::Regex
    "#{ip} is not an valid ip address"
  else
    'ok'
  end
end

def check_port(port)
  if port.to_s.match(/^\d+$/).nil?
     "#{port} is not a Integer"
  else
    'ok'
  end
end
