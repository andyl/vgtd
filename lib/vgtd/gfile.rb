require File.dirname(File.expand_path(__FILE__)) + '/glist'

class Gfile
  attr_accessor :list, :file

  def initialize(file = "")
    @file = file
    @list = Glist.new(File.read(file)) if File.exist?(file)
  end

  def save
    File.open(@file, 'w') do |f|
      f.puts @list.output
    end
  end
end

