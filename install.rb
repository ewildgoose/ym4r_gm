require 'fileutils'

#Copy the Javascript files
FileUtils.copy(Dir[File.dirname(__FILE__) + '/javascript/*.js'],RAILS_ROOT + '/public/javascripts/')

gmaps_config = RAILS_ROOT + '/config/gmaps_api_key.yml'
unless File.exist?(gmaps_config)
  FileUtils.copy(File.dirname(__FILE__) + '/gmaps_api_key.yml.sample',gmaps_config)
end
