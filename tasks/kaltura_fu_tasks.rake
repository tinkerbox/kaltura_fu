require 'fileutils'
CONFIG = File.join Rails.root, "config"
KALTURA_FU_PATH = File.join Rails.root, "vendor","plugins", "kaltura_fu"

namespace :kaltura_fu do
  
  namespace :install do
    
    desc 'Install the Kaltura Config File'
    task :config do
      config_file = Dir.glob(File.join(KALTURA_FU_PATH,"config","kaltura.yml"))
      
      existing_config_file = File.join(CONFIG,"kaltura.yml")
      unless File.exists?(existing_config_file)
        FileUtils.cp_r config_file, CONFIG 
        puts "Config File Loaded"
      else
        puts "Config File Already Exists"
      end
    end
    
    task :all,
         :needs => ['kaltura_fu:install:config'] do
      puts "Kaltura Fu has been installed!"
      puts "---"
    end
    
  end
  
end

