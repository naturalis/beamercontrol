require 'yaml'
def list
  result = Array.new
  Dir["./beamers.d/*.yaml"].each do |f|
    b = YAML.load_file(f)
    result << b['name']
  end
  {"beamers" => result }
end
