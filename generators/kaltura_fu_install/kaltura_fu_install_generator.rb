class KalturaFuInstallGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.directory "config"
      m.file "kaltura.yml", "config/kaltura.yml"
      
      m.directory "public/javascripts"
      m.file "kaltura_upload.js" , "public/javascripts/kaltura_upload.js"
    end
  end
end