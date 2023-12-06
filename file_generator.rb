require 'fileutils'
require 'pathname'

class FileGenerator
  def create(file, mode)
    #STDERR.puts "creating file '#{file}' with mode '#{mode}'"
    dir = Pathname.new(file).dirname
    FileUtils.mkdir_p(dir) unless Dir.exist?(dir)

    tstart = Time.now.utc
    f = File.new(file, mode)
    f.close
    log_data(tstart, file, "create")
  end

  def modify(file, data)
    #STDERR.puts "modifying file '#{file}' with data '#{data}'"
    tstart = Time.now.utc
    File.open(file, "a") do |f|
      f.write(data)
    end
    log_data(tstart, file, "modify")
  end

  def delete(file)
    #STDERR.puts "deleting file '#{file}'"
    tstart = Time.now.utc
    File.delete(file)
    log_data(tstart, file, "delete")
  end

private

  def log_data(tstart, file, activity)
    pid = Process.pid
    username, pname, command = `ps -o user=,comm=,command= -p #{pid}`.strip.split(" ")
    {
      "Timestamp": tstart,
      "FilePath": file,
      "ActivityDescriptor": activity,
      "Username": username,
      "ProcessName": pname,
      "ProcessCommandLine": command,
      "ProcessID": pid
    }
  end
end

