#!/usr/bin/env ruby
bundle_path "vendor/bundled"
bin_path    "vendor/bundled/bin"
source      "http://gemcutter.org"

# Required core gems
gem "rails",                "2.3.5"
gem "rake"                 
gem "dm-core",              "0.10.2"
gem "dm-reflection",        "0.0.1", :path => "vendor/gems/dm-reflection-0.0.1"
gem "dm-timestamps"  
gem "dm-validations"
gem "dm-is-nested_set"
gem "dm-ar-finders"
gem "dm-serializer",        "0.10.2", :path => "vendor/gems/dm-serializer-0.10.2"
gem "dm-aggregates"
gem "dm-types"
gem "dm-persevere-adapter", "0.44.0", :require_as => nil
gem "do_sqlite3",           "0.10.1", :require_as => nil
gem "rails_datamapper"

# Extra supporting gems
# gem "authlogic",            "2.1.3"
gem "fastercsv"
gem "carrierwave"

# Build/CI gems that are just good for us to use.
gem "yardstick"

# JRUBY sensitive gems
if defined?(JRUBY_VERSION)
  gem "json_pure",         '~>1.2.0',    :require_as => nil
  gem "ruby-debug-base",   "0.10.3.1", :require_as => nil, :only => [:development, :test],
                                       :path => "vendor/extra_gems/ruby-debug-base-0.10.3.1-java"
  gem "ruby-debug",                    :require_as => nil, :only => [:development, :test]
  # When in "production" we run with jruby, so we include the adapters for other databases.
  #gem "do_mysql",             "0.10.1", :require_as => nil
  #gem "do_postgres",          "0.10.1", :require_as => nil
else
  gem "json",      "~>1.2.0", :require_as => nil
end

# Testing-only gems
gem 'rspec',        '~>1.3.0', :only => :test, :require_as => nil
gem 'rspec-rails',  '~>1.3.2', :only => :test, :require_as => 'spec/rails'
gem 'factory_girl', '~>1.2.3', :only => [:test, :cucumber]
gem 'ZenTest',               :only => [:test, :cucumber]
gem 'redgreen',              :only => [:test, :cucumber]
gem 'cucumber',              :only => [:test, :cucumber]
gem 'cucumber-rails',        :only => [:test, :cucumber]
gem 'webrat',                :only => [:test, :cucumber]
gem 'selenium-client',       :only => [:test, :cucumber]