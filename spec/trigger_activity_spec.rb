require_relative '../trigger_activity'

describe TriggerActivity do
  it "raises on unknown activity type" do
    logger = double("logger")

    activities = [{ activity: "Nonexistent" }]
    expect { described_class.new(activities, logger).process }.
      to raise_error("Can't trigger unknown activity 'Nonexistent'")
  end

  it "triggers ProcessStart activity" do
    file = 'some.exe'
    args = '-p there -n here'
    data = '{something: "else"}'

    logger = double("logger")
    expect(logger).to receive(:log).with(data)

    pg = double("process_generator")
    expect(pg).to receive(:start).with(file, args).and_return(data)
    expect(ProcessGenerator).to receive(:new).and_return(pg)

    activities = [{ activity: "ProcessStart", file: file, args: args }]
    described_class.new(activities, logger).process
  end

  it "triggers FileCreate activity" do
    file = '/tmp/somwhere/createme.txt'
    mode = 'a'
    data = '{something: "different"}'

    logger = double("logger")
    expect(logger).to receive(:log).with(data)

    fg = double("file_generator")
    expect(fg).to receive(:create).with(file, mode).and_return(data)
    expect(FileGenerator).to receive(:new).and_return(fg)

    activities = [{ activity: "FileCreate", file: file, mode: mode }]
    described_class.new(activities, logger).process
  end

  it "triggers FileModify activity" do
    file = '/tmp/somewhere.txt'
    append = 'add this text'
    data = '{something: "modified"}'

    logger = double("logger")
    expect(logger).to receive(:log).with(data)

    fg = double("file_generator")
    expect(fg).to receive(:modify).with(file, append).and_return(data)
    expect(FileGenerator).to receive(:new).and_return(fg)

    activities = [{ activity: "FileModify", file: file, append: append }]
    described_class.new(activities, logger).process
  end

  it "triggers FileDelete activity" do
    file = '/tmp/deleteme.txt'
    data = '{something: "deleted"}'

    logger = double("logger")
    expect(logger).to receive(:log).with(data)

    fg = double("file_generator")
    expect(fg).to receive(:delete).with(file).and_return(data)
    expect(FileGenerator).to receive(:new).and_return(fg)

    activities = [{ activity: "FileDelete", file: file }]
    described_class.new(activities, logger).process
  end

  it "triggers NetworkConnect activity" do
    ip = '127.0.0.1'
    port = '8888'
    protocol = 'tcp'
    data = 'send me tcp'
    log_data = '{another: "sent"}'

    logger = double("logger")
    expect(logger).to receive(:log).with(log_data)

    ng = double("networ_generator")
    expect(ng).to receive(:connect).with(ip, port, protocol, data).and_return(log_data)
    expect(NetworkGenerator).to receive(:new).and_return(ng)

    activities = [
      { activity: "NetworkConnect", ip: ip, port: port, protocol: protocol, data: data}
    ]
    described_class.new(activities, logger).process
  end
end

