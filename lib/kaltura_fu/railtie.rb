require 'kaltura_fu'
require 'kaltura_fu/view_helpers'
require 'rails'

module KalturaFu
  class Railtie < Rails::Railtie
    initializer 'install kaltura_fu' do
      $: << File.dirname(__FILE__) + '/../lib'
    
      ActionView::Base.send :include, KalturaFu::ViewHelpers

      kaltura_yml = File.join(Rails.root,'config','kaltura.yml')

      if File.exists?(kaltura_yml)
        config_file = YAML.load_file(kaltura_yml)[Rails.env]
        KalturaFu.config = config_file.symbolize_keys        
        
        unless[:partner_id,:subpartner_id,:administrator_secret].all? {|key| KalturaFu.config.key?(key)}
          warn "Kaltura config requires :partner_id, :subpartner_id, and :administrator_secret keys"
        end
      else 
        #raise RuntimeError, "Unable to find \"config/kaltura.yml\" file."
        warn "Unable to find \"config/kaltura.yml\" file.  Please run kaltura_fu:install generator."
      end
        
    end
  end
end