require 'radix62'
require File.dirname(File.expand_path(__FILE__)) + '/gtask'
require File.dirname(File.expand_path(__FILE__)) + '/gblock'

class Gloader

  attr_accessor :string, :task_list, :header_list, :blocks

  def initialize(string = "")
    @string = string
    @task_list = []
    return [] if string.empty?
    load_data
    set_handles
		cleanup_notes
    consolidate_headers
    generate_blocks
    assign_filters
  end

  def tasks
    @task_list.select {|x| x.class == Gtask }
  end

  def load_data(string = @string)
    @task_list = string.lines.map do |line|
      task = Gtask.new(line)
      task.valid_input? ? task : line
    end
  end

  # valid characters for the handle are [A-Za-z0-9] (62 chars in total)
  # we use a 3-digit handle - with a possible 62*62*62=238328 combinations
  def new_handle
    '!' + rand(238327).encode62
  end

  def set_handles(task_list = @task_list)
    handles = []
    task_list.each do |task|
      if task.class == Gtask
        task.handle = new_handle if task.handle.empty?
        until ! handles.include?(task.handle) # loop until a unique handle is found
          task.handle = new_handle
        end
        handles << task.handle
      end
    end
    @task_list = task_list
  end

  def cleanup_notes(task_list = @task_list)
    handles = []
    task_list.each do |task|
      if task.class == Gtask
        task.note = task.note.gsub(/\[ +/, "[").gsub(/ +\]/,"]")
      end
    end
    @task_list = task_list
  end

  def has_filter?(string)
    string.match(/\{[=\:\-@\*\#][A-z0-9\/\-\_]*\}/)
  end

  def consolidate_headers(array = @task_list)
    @header_list = array.reduce([]) do |a, v|
      if v.class == Gtask || a.last.class == Gtask
        a << v
      else
        if a.empty? || has_filter?(a.last)
          a << v
        else
          a.last << v
        end
      end
      a
    end
  end

  def generate_blocks(array = @header_list)
    @blocks = array.reduce([Gblock.new]) do |a,v|
      if v.class == Gtask
        a.last.tasks << v
      else
        a << Gblock.new(v)
      end
      a
    end
    @blocks.shift if @blocks.first.text.empty? && @blocks.first.tasks.empty?
    @blocks
  end

  def assign_filters(array = @blocks)
    array.each do |block|
      x = block.text.match(/\{([=\:@\-\*\#][A-z0-9_\-\/]*)\}/)
      block.filter = x.nil? ? "" : x[1]
    end
  end

end
