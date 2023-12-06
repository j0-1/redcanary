require 'socket'

class NetworkGenerator
  def connect(ip, port, protocol, data)
    #STDERR.puts "network conntect to '#{ip}' port '#{port}' with protocol '#{protocol}' sending data '#{data}'"
    tstart = Time.now.utc
    if protocol == "tcp"
      send_tcp_data(ip, port, data)
    elsif protocol == "udp"
      send_udp_data(ip, port, data)
    else
      raise "Can't send network data using unknown protocol '#{protocol}'"
    end
    log_data(tstart, ip, port, protocol, data.size)
  end

private

  def send_tcp_data(ip, port, data)
    t = TCPSocket.new(ip, port, connect_timeout: 5)
    t.write(data)
    t.close
  end

  def send_udp_data(ip, port, data)
    UDPSocket.new.send(data, 0, ip, port)
  end

  def local_ip
    addr_infos = Socket.ip_address_list
    local_ip = addr_infos.select(&:ipv4?).reject(&:ipv4_loopback?)[0]
    "#{local_ip.ip_address}:#{local_ip.ip_port}"
  end

  def log_data(tstart, ip, port, protocol, data_size)
    pid = Process.pid
    username, pname, command = `ps -o user=,comm=,command= -p #{pid}`.strip.split(" ")
    {
      "Timestamp": tstart,
      "Username": username,
      "Destination": "#{ip}:#{port}",
      "Source": local_ip,
      "AmountOfDataSent": data_size,
      "Protocol": protocol,
      "ProcessName": pname,
      "ProcessCommandLine": command,
      "ProcessID": pid,
    }
  end
end

