require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

namespace :gem do
Bundler::GemHelper.install_tasks
end

require 'rake'
require 'rspec/core/rake_task'

def break() puts '*' * 60; end

task :default => :msg

task :msg do
  puts "Use 'rake -T' to see rake options"
end

desc "Run console with live environment"
task :console do
  require 'irb'
  require 'irb/completion'
  require 'vt_util/ar_obj'
  require 'vt_util/tropo_team'
  require 'vt_util/tropo_app'
  ARGV.clear
  IRB.start
end
task :con => :console

namespace :db do

  task :environment do
    require 'vt_util/ar_obj'
  end

  desc "Remove all databases"
  task :drop do
    Dir["ar_obj/*/*.sqlite3"].each {|f| puts "Dropping #{f}"; File.delete(f)}
  end

  desc "Run database migration"
  task :migrate => :environment do
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("ar_obj/db/migrate")
  end

  desc "Remove all data from database"
  task :reset => :environment do
    puts "Removing all database records"
    User.destroy_all
    Team.destroy_all
    Group.destroy_all
    Workspace.destroy_all
    App.destroy_all
    Plugin.destroy_all
  end

  desc "Load seed data"
  task :seed => [:environment, :reset] do
    puts "Loading Seed Data"
    require 'db/seed'
  end

end

desc "Run all specs"
task :spec do
  cmd = "rspec -O spec/spec.opts spec/**/*_spec.rb"
  puts "Running All Specs"
  puts cmd
  system cmd
end

namespace :spec do
  desc "Show spec documentation"
  task :doc do
    cmd = "rspec -O spec/spec.opts --format documentation spec/**/*_spec.rb"
    puts "Generating Spec documentation"
    puts cmd
    system cmd
  end

  desc "Generate HTML documentation"
  task :html do
    outfile = '/tmp/spec.html'
    cmd = "rspec -O spec/spec.opts --format html spec/**/*_spec.rb > #{outfile}"
    puts "Generating HTML documentation"
    puts cmd
    system cmd
    puts "HTML documentation written to #{outfile}"
  end

end

namespace :doc do

  task :rcov_cleanup do
    system "rm -rf coverage"
  end

  desc ""
  RSpec::Core::RakeTask.new(:run_rcov) do |t|
    t.rcov = true
    t.rcov_opts = %q[--exclude "/home" --exclude "spec"]
    t.verbose = true
  end

  desc "Generate coverage report"
  task :rcov => [:rcov_cleanup, :run_rcov] do
    puts "Rcov generated - view at 'coverage/index.html'"
  end

  task :rdoc_cleanup do
    system "rm -rf doc"
  end

  desc "Generate Rdoc"
  task :rdoc => :rdoc_cleanup do
    system "rdoc lib/*.rb README.rdoc -N --main README.rdoc"
    puts "Rdoc generated - view at 'doc/index.html'"
  end

  desc "Remove all Rcov and Rdoc data"
  task :cleanup => ['spec:rcov_cleanup', :rdoc_cleanup] do
    puts "Done"
  end
  task :clean => :cleanup

end

VT_APP_DIR = File.dirname(File.expand_path(__FILE__)) + "/../vtapp"

desc "Sync Models and Migrations"
task :sync do
  puts "Syncing Models and Migrations"
  system "cp #{VT_APP_DIR}/app/models/* lib/vt_util/ar_obj/models"
  system "cp #{VT_APP_DIR}/db/migrate/* lib/vt_util/ar_obj/db/migrate"
end
  
#class Db < Thor
#  no_tasks do
#    def environment
#      require 'active_record'
#      require 'sqlite3'
#      ActiveRecord::Base.establish_connection(
#        :adapter => 'sqlite3',
#        :database =>  'dev/db/database.sqlite3'
#      )
#    end
#  end
#
#  desc "delete", "Delete the Database"
#  def delete
#    puts "Deleting the database"
#    system "rm -f dev/db/*.sqlite3"
#  end
#
#  desc "migrate", "Migrate the Database"
#  def migrate
#    environment
#    system "rm -f dev/db/*.sqlite3"
#    ActiveRecord::Migration.verbose = true
#    ActiveRecord::Migrator.migrate("dev/db/migrate")
#  end
#end

# class Tropo < Thor
#   include VtUtil::Plugin
#   TEAM_CFG = team_dir + '/
# 
#   no_tasks do
#     def update_params(params)
#       obj = TropoTeam.read_obj(TEAM_CFG).merge(params)
#       obj.write_obj
#       invoke :list, []
#     end
#   end
# 
#   desc "list", "Show Tropo Parameters"
#   def list
#     obj = TropoTeam.read_obj(TEAM_CFG)
#     nearest = obj.nearest_exchanges.first
#     n_str   = "#{nearest} - #{AreaCode.new(nearest).info}"
#     t_str   = "#{obj.area_code} - #{AreaCode.new(obj.area_code).info}"
#     break_str = '*' * 60
#     puts break_str
#     puts "            Username: #{obj.username}"
#     puts "            Password: #{obj.password.gsub(/./,'*')}"
#     puts "            Cfg File: #{obj.filepath}"
#     puts "        Inbound Href: #{obj.url}"
#     puts "    Target Area Code: #{t_str}"
#     puts " > Nearest Available: #{n_str}"
#     puts break_str
#   end
# 
#   desc "auth USERNAME PASSWORD", "Set Tropo username and password"
#   def auth(username, password)
#     update_params({:username => username, :password => password})
#   end
# 
#   desc "href URL", "Set base URL for inbound calls from Tropo"
#   def href(url)
#     update_params({:url => url})
#   end
# 
#   desc "code CODE", "Set target area code prefix."
#   def code(code)
#     update_params({:area_code => code})
#   end
# 
#   desc "exchanges", "List available area code exchanges."
#   def exchanges
#     obj = TropoTeam.read_obj(TEAM_CFG)
#     obj.update_exchanges
#     obj.exchanges.keys.sort.each {|x| puts x}
#   end
# end
# 
# class Tr < Tropo
# end
# 
