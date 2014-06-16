#--
# Copyright (c) 2010 Velir Studios
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

##
# The KalturaFu module provides a singleton implementation for Kaltura API interaction.  
# It stores session and API client information so that they do not need to be reset.
#
# @author Patrick Robertson
#
##
require 'rubygems'
require 'kaltura'
require 'active_support/all'
require 'kaltura_fu/configuration'
require 'kaltura_fu/session'
require 'kaltura_fu/entry'



module KalturaFu
  #Initilize the configuration and send the ViewHelpers into ActionView::Base when it's a Rails 3 and above app.
  require 'kaltura_fu/railtie' if defined?(Rails) && Rails.version.split(".").first > "2"
  
  extend Session
end
