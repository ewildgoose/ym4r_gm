require 'gm_plugin/mapping'
require 'gm_plugin/map'
require 'gm_plugin/control'
require 'gm_plugin/point'
require 'gm_plugin/overlay'
require 'gm_plugin/layer'
require 'gm_plugin/helper'

module Ym4r
  module GmPlugin
    class GMapsAPIKeyConfigFileNotFoundException < StandardError
    end
    
    unless File.exist?(RAILS_ROOT + '/config/gmaps_api_key.yml')
      raise GMapsAPIKeyConfigFileNotFoundException.new("File RAILS_ROOT/config/gmaps_api_key.yml not found")
    else
      GMAPS_API_KEY = YAML.load_file(RAILS_ROOT + '/config/gmaps_api_key.yml')[ENV['RAILS_ENV']]
    end
  end
end

include Ym4r::GmPlugin
