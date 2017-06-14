require File.dirname(File.expand_path(__FILE__)) + '/gtask'

class Gblock

  attr_accessor :tasks, :text, :filter

  def initialize(input = "")
    @text = input
    @tasks = []
    @filter = ""
    set_filter
    self
  end

  def set_filter
    x = @text.match(/\{([=\:@\-\*\#][A-z0-9_\-\/]*)\}/)
    @filter = x.nil? ? "" : x[1]
  end

  def output(widths = {})
    task_out = @tasks.map {|gtask| gtask.output_nl(widths)}.join("")
    @tasks.empty? ? @text : @text + task_out
  end
  
  def match_one(criteria, t)
    [t.category, t.date, t.context, t.project, t.priority].include? criteria
  end

  def delete_tasks(criteria)
    return_tasks = @tasks.find_all {|t| match_one(criteria, t)}
    @tasks = @tasks.delete_if {|t| match_one(criteria, t)}
    return_tasks
  end

  def add_tasks(tasks)
    @tasks = @tasks + tasks
  end

end


