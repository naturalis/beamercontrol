#!/usr/bin/env ruby

require 'net/telnet'
require 'resolv'
require 'yaml'
require 'pp'
require 'optparse'
Dir["#{File.join(File.expand_path(File.dirname(__FILE__)).split('/')[0..-1])}/lib/*.rb"].each { |l| require l}

o = {}
o[:list] = false
o[:options] = false
o[:testmode] = false
o[:command] = false
o[:host] = '127.0.0.1'
o[:port] = '2000'
o[:extron_port] = ''

OptionParser.new do |opts|
  opts.banner = "Usage: beamer.rb [options]"
  opts.on('-t','--test','Print telnet, not run them') do |t|
    o[:testmode] = t
  end
  opts.on("-l","--list","list beamer options") do |p|
    o[:list] = p
    list.each {|l| puts l}
    exit
  end
  opts.on('-b','--beamer BEAMER',String,'choose beamer type') do |b|
    o[:beamer] = b
  end
  opts.on("-o","--options","list options of beamer") do |h|
    o[:options] = h
  end
  opts.on("-c","--command COMMAND",String,"command to send") do |c|
    o[:command] = c
  end
  opts.on("-p","--port PORT","telnet port to send to") do |c|
    o[:port] = c
  end
  opts.on("--host IP","ip of the beamer or extron") do |c|
    o[:host] = c
  end
  opts.on("--extronport PORT","port of beamer on extron") do |c|
    o[:extron_port] = c
  end
end.parse!

if o[:options] == true
  if options(o[:beamer]).has_key? 'options'
    options(o[:beamer])['options'].each { |opt| puts opt}
  else
    puts options(o[:beamer])['error']
  end
  exit
end

if o[:command]
  #check_beamer_name(o[:beamer])
  #check_beamer_options(o[:beamer],o[:command])
  #check_ip(o[:host])
  #check_port(o[:port])
  puts sendtelnet(
    host: o[:host],
    port: o[:port],
    beamer: o[:beamer] ,
    command: o[:command],
    testmode: o[:testmode] ,
    extron_port: o[:extron_port])['result']
    exit
end
