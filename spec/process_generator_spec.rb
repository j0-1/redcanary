require_relative '../process_generator'

describe ProcessGenerator do
  it "spawns a process" do
    exe = '/bin/touch'
    args = '/tmp/some/weird/file'
    command = "#{exe} #{args}"
    pid = 12345

    expect(Process).to receive(:spawn).
      with(command, [:out, :err] => "/dev/null").and_return(pid)
    expect(Process).to receive(:detach).with(pid).and_return(true)

    described_class.new.start(exe, args)
  end
end

