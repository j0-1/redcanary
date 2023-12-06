require_relative '../logger'

describe Logger do
  it "handles empty data" do
    expect { described_class.new($stdout).log(nil) }.to output("null\n").to_stdout 
  end

  it "handles non-hash data" do
    expect { described_class.new($stdout).log(3) }.to output("3\n").to_stdout 
    expect { described_class.new($stdout).log("works") }.to output("\"works\"\n").to_stdout 
  end

  it "handles valid data" do
    expect { described_class.new($stdout).log({hello: "there"}) }.
      to output("{\"hello\":\"there\"}\n").to_stdout 
  end
end

