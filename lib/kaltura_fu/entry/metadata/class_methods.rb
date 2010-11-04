module KalturaFu
  module Entry
    module Metadata
      module ClassMethods
        
        # Contains the names of the generated attribute methods.
        def generated_methods #:nodoc:
          @generated_methods ||= Set.new
        end

        def generated_methods?
          !generated_methods.empty?
        end
        
        ##
        # This method is called from with method_missing.  It generates
        # actual methods for all the valid Kaltura::Media Entry methods
        # the first time a dynamic getter/setter/adder is called.
        ##
        def define_attribute_methods
          return if generated_methods?
          valid_entry_attributes.each do |name|
            define_set_method(name)
            define_get_method(name)
            define_add_method(name) if valid_add_attribute?(name)
          end        
        end
      
        ##
        # Defines the set method for a specific Media Entry attribute
        ##
        def define_set_method(attr_name) 
          evaluate_attribute_method( attr_name, 
            "def set_#{attr_name}(entry,new_value);set_attribute('#{attr_name}',entry,new_value);end", 
            "set_#{attr_name}"
          )
        end

        ##
        # defines a get methods 
        ##
        def define_get_method(attr_name)
          evaluate_attribute_method( attr_name, 
            "def get_#{attr_name}(entry);get_entry(entry).send('#{attr_name}');end", 
            "get_#{attr_name}"
          )
        end

        def define_add_method(attr_name) 
          evaluate_attribute_method( attr_name, 
            "def add_#{attr_name}(entry,new_value);add_attribute('#{attr_name}',entry,new_value);end", 
            "add_#{attr_name}"
          )
        end
        
        def evaluate_attribute_method(attr_name, method_definition, method_name=attr_name) 
          generated_methods << method_name

          begin
            class_eval(method_definition, __FILE__, __LINE__) 
          rescue SyntaxError => err
            generated_methods.delete(attr_name) 
          end
        end
      
      end
    end
  end
end
      
      