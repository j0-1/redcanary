require_relative "logger"
require_relative "process_generator"
require_relative "file_generator"
require_relative "network_generator"

class TriggerActivity
  def initialize(activities, logger)
    @activities = activities
    @logger = logger
  end

  def process
    @activities.each do |activity|
      trigger(activity)
    end
  end

private

  def trigger(activity)
    data = case activity[:activity]
    when "ProcessStart"
      ProcessGenerator.new.start(activity[:file], activity[:args])
    when "FileCreate"
      FileGenerator.new.create(activity[:file], activity[:mode])
    when "FileModify"
      FileGenerator.new.modify(activity[:file], activity[:append])
    when "FileDelete"
      FileGenerator.new.delete(activity[:file])
    when "NetworkConnect"
      NetworkGenerator.new.connect(
        activity[:ip],
        activity[:port],
        activity[:protocol],
        activity[:data]
      )
    else
      raise "Can't trigger unknown activity '#{activity[:activity]}'"
    end

    @logger.log(data)
  end
end

