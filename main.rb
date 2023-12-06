require 'json'
require_relative 'logger'
require_relative 'trigger_activity'

# This starts triggering activities, it reads from an input json file either
# from stdin (e.g. `ruby main.rb < test.json`) or from the arguments like this
# `ruby main.rb test.json`.  If arguments are used, multiple files can be
# passed and they will be concatenated, possibly making your test suite more
# readable (this is a feature of ARGF), 
# e.g. `ruby main.rb test1.json test2.json`
#
# The default logging here sends to STDOUT, so capture it as necessary, e.g.
# `ruby main.rb test.json > log.json`
#
# There are several example input files in the 'examples' directory, e.g.
# you can run `ruby main.rb examples/testall.json > log.json` to exercise most
# functionality.  For this to succeed, run the tcp server to catch the network
# activity first via `servers/test_receive_tcp.rb`.  There is also a udp server
# in there for the testnetworkconnectudp.json example which sends udp.

activities = JSON.parse(ARGF.read, {symbolize_names: true})
TriggerActivity.new(activities, Logger.new(STDOUT)).process

