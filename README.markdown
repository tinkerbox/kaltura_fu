Kaltura_Fu
--------------
**Homepage**: [http://www.velir.com](http://www.velir.com)
**Author**: [Patrick Robertson](mailto:patrick.robertson@velir.com)
**Copyright**: 2010
**License**: [MIT License](file:MIT-LICENSE)

About Kaltura
----------------
[Kaltura](http://kaltura.org/) is an open source video streaming service.

About Kaltura_Fu
------------------

kaltura_fu is a gem for rails that extends the basic functionality of the Kaltura ruby client and adds in some Rails view helpers to generate video players, thumbnails, and the uploader.  The Kaltura session and client are managed in a singleton pattern, and there are additional modules that allow you to more perform basic API actions in a more efficient manner.

Installation:
-------------
Install the gem with the command:
    
    gem install kaltura_fu --pre
Run: 
  
    script/generate kaltura_fu_install
    
This will install the kaltura.yml file into your application's config directory and the kaltura_upload.js into the application's public/javascripts directory.
	

Documentation:
------
The full documentation is located [here](http://rdoc.info/github/Velir/kaltura_fu/).

Copyright (c) 2010 [Velir Studios](http://www.velir.com), released under the MIT license