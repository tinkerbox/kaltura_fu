require 'kaltura_fu'
require 'kaltura_fu/view_helpers'
require 'rails'

module KalturaFu
  class Railtie < Rails::Railtie
    initializer 'install kaltura_fu' do
      $: << File.dirname(__FILE__) + '/../lib'
    
      ActionView::Base.send :include, KalturaFu::ViewHelpers
    end
  end
end