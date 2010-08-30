# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: tomcat.rake
# 
#

require 'slash_path'
require 'yaml'
require 'net/http'

namespace :tomcat do
  BLAZEDS_CMD = (ENV['CATALINA_BASE'] && ENV['CATALINA_HOME']/:bin/'catalina.sh') || ::Rails.root.to_s/'vendor/blazeds/tomcat/bin/catalina.sh' || 'catalina.sh'
 
  desc "Start the tomcat instance for the current environment (blazeds & persevere)."
  # task :start => [:version, :stop, :create] do
  task :start do
    sh "#{BLAZEDS_CMD} start" do |ok,resp|
      unless ok
        fail "Start Failed!  Is BlazeDS installed?"
      else
        puts "Started background blazeds instance on port 8400..."
      end
    end
  end

  desc "Stop the tomcat instance for the current environment (blazeds & persevere)."
  # task :stop => :version do
  task :stop do
    sh "#{BLAZEDS_CMD} stop" do |ok,resp|
      unless ok
        fail "Shutdown Failed!  Is BlazeDS running?"
      end
    end
  end

end