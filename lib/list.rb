require 'yaml'
def list
  Dir["./beamers.d/*.yaml"].each do |f|
    b = YAML.load_file(f)
    puts b['name']
  end
  exit
end
