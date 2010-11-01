module KalturaFu
  module Entry    
    ##
    # @private
    ##
    def self.included(base)
      base.extend ClassMethods
      base.class_eval do 
        include Metadata
        include InstanceMethods
      end
      super
    end
    
  end #Entry
end #KalturFu