require 'socket'

Socket.udp_server_loop(8089) do |msg, msg_src|
  puts msg
end

