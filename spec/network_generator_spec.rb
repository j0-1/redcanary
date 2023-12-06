require_relative '../network_generator'

describe NetworkGenerator do
  it "sends tcp data" do
    data = 'send me tcp'
    ip = '127.0.0.1'
    port = '9999'

    sd = double("tcpsocket")
    expect(sd).to receive(:write).with(data).and_return(true)
    expect(sd).to receive(:close).and_return(true)
    expect(TCPSocket).to receive(:new).with(ip, port, connect_timeout: 5).and_return(sd)

    described_class.new.connect(ip, port, 'tcp', data)
  end

  it "sends udp data" do
    data = 'send me udp'
    ip = '127.0.0.1'
    port = '9900'

    sd = double("udpsocket")
    expect(sd).to receive(:send).with(data, 0, ip, port).and_return(true)
    expect(UDPSocket).to receive(:new).and_return(sd)

    described_class.new.connect(ip, port, 'udp', data)
  end
end

