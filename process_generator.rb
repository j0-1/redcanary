class ProcessGenerator
  def start(exe, args)
    command = "#{exe} #{args}" # using this form for spawn to go through shell
    pid = Process.spawn(command, [:out, :err] => "/dev/null") # discarding stdin/stdout

    # get the user, command, command line and start time in utc via ps
    ps_info = `TZ=UTC0 ps -o user=,comm=,command=,lstart= -p #{pid}`.strip
    Process.detach(pid) # detaching for now, might want results at some later time...
    log_data(pid, command, ps_info)
  end

private

  def log_data(pid, command, ps_info)
    sps = ps_info.split(" ")
    username = sps[0]
    process_name = sps[1]
    ps_command = sps[2]
    lstart = sps[3..]&.join(" ")
    {
      "StartTime": lstart, # in utc because of the TZ=UTC0 in the ps command
      "Username": username,
      "ProcessName": process_name,
      # the following uses the ps_command instead of the passed in command, 
      # either can be used depending on exactly what is captured by the EDR
      "ProcessCommandLine": ps_command,
      "ProcessID": pid,
    }
  end
end

