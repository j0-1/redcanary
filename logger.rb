require 'json'

class Logger
  def initialize(file)
    @file = file
  end

  def log(data)
    @file.write(data.to_json)
    @file.write("\n")
  end
end

