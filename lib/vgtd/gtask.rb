require 'time'
require 'date'
require 'active_support/all'
# require 'active_support/core_ext'

class Gtask

  attr_accessor :input, :handle, :category, :project, :date, :sdate
  attr_accessor :context, :priority, :contact, :task, :note

  def grab(string, regex, default = "")
    x = string.scan(regex)
    x.empty? ? default : x.last.last
    # (x = regex.match(string)) ? x[-1].strip : default
  end

  def initialize(input = "")
    @input    = input.chomp
    @handle   = grab(input, /(![A-z\d][A-z\d][A-z\d])/)
    @category = grab(input, /(=[IAWSTRXiawstrx])/  , "=I")
    @project  = grab(input, /(\:[\w\/]*)/  )
    @context  = grab(input, /(@[\w]*)/   )
    @priority = grab(input, /(\-[HMLhml])/  )
    @contact  = grab(input, /(#[\w]*)/  )
    @task     = grab(input, /(\|[^\[]*)/ )
    @date     = grab(input, /(\/[^ ]*)/ )
    @note     = grab(input, /(\[.*\])/   )
    @subtasks = []
    remove_empty_fields
    cleanup_task_field
    setup_date
    capitalize_fields
  end

  def valid_input?
    @input[0] == "="[0] || @input[0] == "!"[0]
  end

  def setup_date(date = @date)
    @date = date
    newdate = date.gsub("/","").chomp
    @sdate = 2.years.from_now

    begin
      x = ""
      # x = eval(newdate)
      if false # x.class == Time
      # if x.class == Time
        @sdate = x
        @date  = "/" + x.strftime("%b%d").downcase unless @date.empty?
      else
        @date = ""
      end
    rescue
      begin
        @sdate = Date.parse(newdate).to_time
        @date  = "/" + @sdate.strftime("%b%d").downcase unless @date.empty?
      rescue
        @date = ""
      end
    end
  end

  def new_date(time)
    @sdate = time
    @date = "/" + @sdate.strftime("%b%d").downcase
  end

  def capitalize_fields
    @priority = @priority.upcase
    @category = @category.upcase
  end

  def complete?
    @category == "=X"
  end

  def cleanup_task_field
    @task = @task.gsub(/![A-z\d][A-z\d][A-z\d]/,'')
    @task = @task.gsub(/-[HMLhml]/,'')
    @task = @task.gsub(/@[^ ]*/,'')
    @task = @task.gsub(/\/[^ ]*/,'')
    @task = @task.gsub(/\:[^ ]*/,'')
    @task = @task.gsub(/#[^ ]*/,'')
    @task = @task.gsub(/=[^ ]*/,'')
    @task = @task.squeeze(' ').strip
  end

  def remove_empty_fields
    @handle   = "" if @handle.length   == 1
    @category = "" if @category.length == 1
    @project  = "" if @project.length  == 1
    @context  = "" if @context.length  == 1
    @priority = "" if @priority.length == 1
    @contact  = "" if @contact.length  == 1
    @note     = "" if @note.length     <= 2
  end

  def output_nl(widths = nil)
    output(widths) + "\n"
  end

  def output(widths = nil)
    field_order = [
      @handle,
      @category,
      @project,
      @context,
      @priority,
      @task,
      @note,
      @contact,
      @date,
    ]
    if widths.nil?
      return field_order.join(' ').squeeze(' ').strip
    end
    field_order = []
    field_order << @handle.ljust(widths[:category])
    field_order << @category.ljust(widths[:category])
    field_order << @project.ljust(widths[:project])   unless widths[:project]  == 0
    field_order << @context.ljust(widths[:context])   unless widths[:context]  == 0
    field_order << @priority.ljust(widths[:priority]) unless widths[:priority] == 0
    field_order << @task.ljust(widths[:task])         unless widths[:task]     == 0
    field_order << @note.strip                        unless @note.empty?
    field_order << @contact.strip                     unless @contact.empty?
    field_order << @date.strip                        unless @date.empty?
    field_order.join(' ').strip
  end

  def update_field(leader, newval)
    value = newval.empty? ? "" : leader + newval
    case leader
      when '!' then @handle   = value
      when '=' then @category = value
      when '@' then @context  = value
      when ':' then @project  = value
      when '-' then @priority = value
      when '#' then @contact  = value
      when '/' then @date     = value
    end
  end

  def category_rank
    case @category
    when '=I' then 1
    when '=A' then 2
    when '=W' then 3
    when '=T' then 4
    when '=S' then 5
    when '=R' then 6
    when '=X' then 7
    else 6
    end
  end

  def priority_rank
    case @priority
    when '-H' then 1
    when '-M' then 2
    when '-L' then 3
    else 4
    end
  end

end

