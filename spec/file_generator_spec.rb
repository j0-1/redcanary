require_relative '../file_generator'

describe FileGenerator do
  it "creates file path" do
    file = '/tmp/some/nonexistant/path/testme.txt'
    dir = Pathname.new(file).dirname

    expect(Dir).to receive(:exist?).with(dir).and_return(false)
    expect(FileUtils).to receive(:mkdir_p).with(dir).and_return(true)
    fh = double('filehandle')
    expect(fh).to receive(:close).and_return(true)
    expect(File).to receive(:new).with(file, 'a').and_return(fh)

    described_class.new.create(file, 'a')
  end

  it "creates file" do
    file = 'anothertext.txt'

    expect(Dir).to receive(:exist?).with(Pathname.new('.')).and_return(false)
    fh = double('filehandle')
    expect(fh).to receive(:close).and_return(true)
    expect(File).to receive(:new).with(file, 'a').and_return(fh)

    described_class.new.create(file, 'a')
  end

  it "modifies file" do
    file = 'modifyme.txt'
    data = "appending...\n"

    fh = double('filehandle')
    allow(fh).to receive(:write).with(data).and_return(true)
    expect(File).to receive(:open).with(file, 'a').and_return(fh)

    described_class.new.modify(file, data)
  end

  it "deletes file" do
    file = 'deleteme.txt'
    expect(File).to receive(:delete).with(file).and_return(true)

    described_class.new.delete(file)
  end
end

