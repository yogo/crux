# Yogo Data Management Toolkit
# Copyright (c) 2011 Montana State University
#
# License -> see license.txt
#
# FILE: export.rake
# 
# Implements tasks to: 
#   create flatfile exports of the database files suitable for import
require 'slash_path'
require 'yaml'

namespace :yogo do

  namespace :export do

    task :init do
      @cfg = YAML.load_file(::Rails.root.to_s/'config'/'database.yml')[::Rails.env]
      @date_dir = Time.now.strftime("%Y-%m-%d")
      @export_dir = ::Rails.root.to_s/'db'/'export'/@date_dir
      sh "mkdir -p #{@export_dir}" unless File.exists?(@export_dir)
    end

    desc "Export the kefed models"
    task :kefed => :init do
      host = 'http://' + @cfg['repositories']['yogo_persevere']['host']
      host += ':' + @cfg['repositories']['yogo_persevere']['port'].to_s
      cd @export_dir do
        dest = "KefedModel.json"
        sh "curl -i -H \"Accept: application/json\" #{host}/KefedModel/ > #{dest}" do |ok,resp|
          unless ok
            fail "Curl failed.  It is likely that persevere is not running, please run `rake persvr:start` then try again."
          end
          dest = "YogoModel.json"
          sh "curl -i -H \"Accept: application/json\" #{host}/crux__yogo_model/ > #{dest}"          
        end
      end
    end

    desc "Export the crux data"
    task :collection => :init do
      db = @cfg['repositories']['collection_data']
      dest = db['database'] + ".sql"
      cd @export_dir do
        sh "mysqldump -u #{db['user']} -p#{db['password']} #{db['database']} > #{dest}"
      end
    end
    
    desc "Export the yogo metadata"
    task :yogo => :init do
      db = ::Rails.root.to_s/@cfg['path']
      cd @export_dir do
        sh "cp #{db} ."
      end
    end
    
    desc "Export the crux data, kefed models and yogo metadata"
    task :all => [:kefed, :collection, :yogo] 
    
    desc "Export all of the crux data and models and create a tgz package"
    task :tgz => [:all] do
      cd @export_dir+'/..' do
        sh "tar --remove-files -czf #{@date_dir}-crux-export.tgz #{@date_dir}"
        rm_rf @export_dir
      end
    end
  end
end

