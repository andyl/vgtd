require 'rubygems'
require 'bundler/setup'

require File.dirname(File.expand_path(__FILE__)) + '/gblock'
require File.dirname(File.expand_path(__FILE__)) + '/gtask'
require File.dirname(File.expand_path(__FILE__)) + '/gloader'

class String
  # this is done to make empty strings show up last in sort results
  def ez
    self.gsub(' ','').empty? ? "ZZZ" : self
  end
end

class Glist

  attr_accessor :tasks, :widths

  def initialize(input = "")
    @loader  = Gloader.new(input)
    @tasks   = @loader.tasks
    @blocks  = @loader.blocks
    @widths  = calc_widths
  end

  def task_by_handle(val)
    x = @tasks.select {|x| x.handle == val}
    x.nil? ? nil : x.first

  end

  # =I Inbox
  # =A Active (next Action)
  # =W Waiting on someone
  # =T Tickler (time triggered)
  # =S Someday/Maybe
  # =R Reference
  # =X DONE

  # ----- Get an array of Tag Values -----
  def categories() %w(=I =A =W =T =S =R =X);  end
  def projects()   get_tags(:project);  end
  def contexts()   get_tags(:context);  end
  def priorities() %w(-H -M -L);        end
  def contacts()   get_tags(:contact);  end

  # ----- Get an array of Tasks selected by Tag Value -----
  def category_tasks(val) @tasks.select {|x| x.category == val}; end
  def project_tasks(val)  @tasks.select {|x| x.project  == val}; end
  def context_tasks(val)  @tasks.select {|x| x.context  == val}; end
  def priority_tasks(val) @tasks.select {|x| x.priority == val}; end
  def contact_tasks(val)  @tasks.select {|x| x.contact  == val}; end
  def date_tasks(val)     @tasks.select {|x| x.date  == val};    end

  # ----- Get an array of tasks selected by value -----
  def find_tasks(val)
    case val[0]
      when ":"[0] then category_tasks(val)
      when "/"[0] then date_tasks(val)
      when "-"[0] then priority_tasks(val)
      when "@"[0] then context_tasks(val)
      when "="[0] then category_tasks(val)
    end
  end

  def gen_tasks
    @tasks = @blocks.reduce([]) {|a,v| a = a + v.tasks}
  end

  def add_tasks(tasks)
    @blocks = [Gblock.new] if @blocks.nil? || @blocks.empty?
    @blocks.last.add_tasks(tasks)
    gen_tasks
    self
  end

  def delete_tasks(val)
    result = @blocks.map {|b| b.delete_tasks(val)}.flatten
    gen_tasks
    result
  end

  def output
    @widths = calc_widths
    x = @blocks.map {|gblock| gblock.output(@widths)}
    x.select {|block| ! block.empty? }.join("")
  end

  def ee(list) list.map{|ggg| ggg.handle}.join(', '); end;

  def filter
    temp_tasks = @tasks
    @blocks.each do |x|
      unless x.filter.empty?
        match_list = select(temp_tasks, x.filter)
        unless match_list.empty?
          temp_tasks = temp_tasks - match_list
          @blocks.each do |y|
            y.tasks = y.tasks - match_list unless x == y
          end
          add_list = match_list - x.tasks
          x.tasks = x.tasks + add_list
        end
      end
    end
  end

  def select(array, sort_option)
    case sort_option[0]
      when "#"[0] then array
      when "="[0] then array.select {|x| x.category == sort_option}
      when ":"[0] then array.select {|x| x.project  == sort_option}
      when "!"[0] then array.select {|x| x.handle   == sort_option}
      when "/"[0] then array.select {|x| x.date     == sort_option}
      when "@"[0] then array.select {|x| x.context  == sort_option}
      when "-"[0] then array.select {|x| x.priority == sort_option}
      when "|"[0] then array.select {|x| x.task     == sort_option}
    end
  end

  def sort_tasks(sort_option="xxx")
    @tasks = case sort_option
      when "handle"   then @tasks.sort { |a,b| han_sort(a) <=> han_sort(b) }
      when "context"  then @tasks.sort { |a,b| ctx_sort(a) <=> ctx_sort(b) }
      when "contact"  then @tasks.sort { |a,b| con_sort(a) <=> con_sort(b) }
      when "project"  then @tasks.sort { |a,b| pro_sort(a) <=> pro_sort(b) }
      when "date"     then @tasks.sort { |a,b| dat_sort(a) <=> dat_sort(b) }
      when "priority" then @tasks.sort { |a,b| pri_sort(a) <=> pri_sort(b) }
      when "none"     then @tasks
      else @tasks.sort              { |a,b| def_sort(a) <=> def_sort(b) }
             end
    self
  end

  def sort(sort_option = "xxx")
    filter
    @blocks.each do |block|
      block.tasks = case sort_option
        when "handle"   then block.tasks.sort { |a,b| han_sort(a) <=> han_sort(b) }
        when "context"  then block.tasks.sort { |a,b| ctx_sort(a) <=> ctx_sort(b) }
        when "contact"  then block.tasks.sort { |a,b| con_sort(a) <=> con_sort(b) }
        when "project"  then block.tasks.sort { |a,b| pro_sort(a) <=> pro_sort(b) }
        when "date"     then block.tasks.sort { |a,b| dat_sort(a) <=> dat_sort(b) }
        when "priority" then block.tasks.sort { |a,b| pri_sort(a) <=> pri_sort(b) }
        when "none"     then block.tasks
        else block.tasks.sort              { |a,b| def_sort(a) <=> def_sort(b) }
      end
    end
    sort_tasks
    self
  end

  def group(group_option)
    strip_groups
    add_groups(group_option)
    sort(group_option)
  end

  private

  def strip_groups
    @blocks.each do |block|
      block.text = block.text.gsub(/\n\{.*\}.*\n?/,"")
      block.text = block.text.gsub(/^\{.*\}.*\n?/,"")
    end
  end

  def get_headers(sym)
    case sym
      when "=" then categories
      when ":" then projects
      when "@" then contexts
      when "-" then priorities
      when "#" then contacts
    end
  end

  def add_groups(sym)
    headers = get_headers(sym)
    new_blocks = headers.map { |header| Gblock.new("\n{#{header}}\n") }
    new_blocks[0] = Gblock.new("{#{headers[0]}}\n")
    @blocks = new_blocks + @blocks
  end

  # used to load GTD data
  def load_data(string = "")
    return [] if string.empty?
    handles = []
    string.map do |line|
      task = Gtask.new(line)
      task.handle = new_handle if task.handle.empty?
      until ! handles.include?(task.handle) # loop until a unique handle is found
        task.handle = new_handle
      end
      handles << task.handle
      task
    end
  end

  # generates a list of tags for a specific category
  def get_tags(category)
    tmp = @tasks.map {|x| x.send(category) }.uniq.sort
    tmp.select {|x| ! x.empty? }
  end

  # ----- Sort Specifications -----

  def han_sort(t)
    [t.handle, t.category_rank, t.project.ez, t.priority_rank, t.context.ez]
  end

  def pri_sort(t)
    [t.priority_rank, t.category_rank, t.project.ez, t.context.ez, t.contact.ez, t.task.ez]
  end

  def ctx_sort(t)
    [t.context.ez, t.category_rank, t.priority_rank, t.project.ez, t.contact.ez, t.task.ez]
  end

  def con_sort(t)
    [t.contact.ez, t.category_rank, t.priority_rank, t.project.ez, t.context.ez, t.task.ez]
  end

  def pro_sort(t)
    [t.project.ez, t.category_rank, t.priority_rank, t.context.ez, t.contact.ez, t.task.ez]
  end

  def dat_sort(t)
    [t.sdate, t.category_rank, t.priority_rank, t.project.ez, t.context.ez, t.contact.ez, t.task.ez]
  end

  def def_sort(t)
    [t.priority_rank, t.category_rank, t.project.ez, t.context.ez, t.contact.ez, t.task.ez]
  end

  # ----- Field Width Calculations -----

  def reset_widths
    {
      :category => 0,
      :project  => 0,
      :context  => 0,
      :priority => 0,
      :date     => 0,
      :contact  => 0,
      :task     => 0
    }
  end

  def get_max(first, second)
    first > second ? first : second
  end

  def calc_widths
    widths = reset_widths
    @tasks.each do |l|
      widths[:category] = get_max(widths[:category], l.category.length)
      widths[:project]  = get_max(widths[:project],  l.project.length )
      widths[:context]  = get_max(widths[:context],  l.context.length )
      widths[:priority] = get_max(widths[:priority], l.priority.length)
      widths[:date]     = get_max(widths[:date],     l.date.length)
      widths[:contact]  = get_max(widths[:contact],  l.contact.length )
      widths[:task]     = get_max(widths[:task],     l.task.length    )
    end
    widths
  end

end


