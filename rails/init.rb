$: << File.dirname(__FILE__) + '/../lib'

require 'rubygems'
require 'kaltura-ruby'
require 'kaltura_fu'

ActionView::Base.send :include, KalturaFu::ViewHelpers