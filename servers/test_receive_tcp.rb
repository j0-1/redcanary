require 'socket'

server = TCPServer.new 8088

loop do
  client = server.accept
  puts client.gets
  client.close
end


