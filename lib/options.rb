require 'yaml'
def options(beamer='none')
  fail if beamer == 'none'
  begin
    YAML.load_file("./beamers.d/#{beamer}.yaml")['commands'].each do |k,v|
      puts '-' + k
    end
  rescue
    puts "Could not load beamertype: #{beamer}"
    exit 1
  end
  exit
end
