require 'yaml'
def options(beamer='none')
  fail if beamer == 'none'
  result = Hash.new
  begin
    result = { "options" => YAML.load_file("./beamers.d/#{beamer}.yaml")['commands'].keys }
  rescue
    result = {"error" => "Could not load beamertype: #{beamer}" }
  end
end
