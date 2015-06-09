require 'socket'
require 'yaml'

response = {
  'some return regex' => "\e0*2*76*1LE",
  'some regex' => "\e0*2*76*3LE",
  '3' => "\e0*2*136LE"
}



server = TCPServer.open(2000)
loop {
  client = server.accept
  puts('-= starting =-')
  data = String.new
  until data.include? "exit\r\n"
    data = client.gets
    resp = "Not found: #{data}"
    puts "incomming: #{data}"
    response.each do |r,c|
      puts "1: #{c}\r\n".dump
      puts "2: #{data}".dump
      if "#{c}\r\n".dump == "#{data}".dump
        puts 'resp found!'
        resp = r
      end
    end
    client.puts(resp)
  end
  puts('-= ending =-')
  client.close
}
