# Yogo Data Management Toolkit
# Copyright (c) 2011 Montana State University
#
# License -> see license.txt
#
# FILE: crux.rake
# 
# Implements tasks to: 
#   start up the crux stack
require 'slash_path'
require 'yaml'

namespace :crux do
  task :start_db do
    Rake::Task['persvr:start'].invoke
    Rake::Task['tomcat:start'].invoke
  end

  task :start => :start_db do
    sh "rails server -d" 
    sh "reset"
  end
  
  task :stop do
    begin
      cd Rails.root / 'tmp' / 'pids' do
        sh 'kill `cat server.pid`' 
      end
    rescue Exception => e
      puts "#{e}\n++ Rails is not running or there is no pids directory."
    end
    Rake::Task['persvr:stop'].invoke
    Rake::Task['tomcat:stop'].invoke
    sh "reset"
  end
end
