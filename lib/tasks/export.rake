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
      @export_dir = ::Rails.root.to_s/'db'/'export'/Time.now.strftime("%Y-%m-%d")
      sh "mkdir -p #{@export_dir}" unless File.exists?(@export_dir)
    end

    desc "Export the kefed models"
    task :kefed => :init do
      host = 'http://' + @cfg['repositories']['yogo_persevere']['host']
      host += ':' + @cfg['repositories']['yogo_persevere']['port'].to_s
      cd @export_dir do
        dest = "KefedModel.json"
        sh "curl -i -H \"Accept: application/json\" #{host}/KefedModel/ > #{dest}"
        dest = "YogoModel.json"
        sh "curl -i -H \"Accept: application/json\" #{host}/crux__yogo_model/ > #{dest}"
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
    
    desc "Export the crux data and kefed models"
    task :all => [:kefed, :collection] 
    
  end
end

