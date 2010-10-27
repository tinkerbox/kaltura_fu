require 'kaltura_fu'
require 'kaltura_fu/view_helpers'
require 'rails'

module KalturaFu
  class Railtie < Rails::Railtie
    initializer 'install kaltura_fu' do
      $: << File.dirname(__FILE__) + '/../lib'
    
      ActionView::Base.send :include, KalturaFu::ViewHelpers

      kaltura_yml = File.join(RAILS_ROOT,'config','kaltura.yml')

      unless File.exists?(kaltura_yml)
        raise RuntimeError, "Unable to find \"config/kaltura.yml\" file."
      end

      config_file = YAML.load_file(kaltura_yml)[Rails.env]
      KalturaFu.config = config_file.symbolize_keys


      unless[:partner_id,:subpartner_id,:administrator_secret].all? {|key| KalturaFu.config.key?(key)}
        raise RuntimeError, "Kaltura config requires :partner_id, :subpartner_id,"+
      		      "and :administrator_secret keys"
      end
    end
  end
end