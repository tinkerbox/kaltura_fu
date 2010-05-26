kaltura_fu
--------------
**Homepage**: [http://github.com/patricksrobertson/kaltura_fu](http://github.com/patricksrobertson/kaltura_fu)
**Author**: [Patrick Robertson](mailto:patrick.robertson@velir.com)
**Copyright**: 2010
**License**: [MIT License](file:LICENSE)

About Kaltura
----------------
[Kaltura](http://kaltura.org/) is an open source video streaming service.

About kaltura_fu
------------------

kaltura_fu is a rails plugin that extends the basic functionality of the Kaltura ruby client and adds in some Rails view helpers to generate video players, thumbnails, and the uploader.

Installation:
-------------
Install the plugin with the command 
	script/plugin install git@github.com:patricksrobertson/kaltura_fu.git
Run 
	rake kaltura_fu:install:all
This will install the config/kaltura.yml file into your application's root directory.

Usage:
------
In your views you can use the following commands currently:
kaltura_thumbnail(entry_id, options={})
kaltura_player_embed(entry_id,options={})
kaltura_upload_embed(options={})

The upload embed is currently not working in plugin form as I haven't extracted all the necessary javascript from the main project.  

To Do's
-------
* Extract the upload javascript into the plugin and setup an installer and include tag.
* Buff the options for the upload script a bit more.  

Copyright (c) 2010 [Patrick Robertson](http://p-rob.me), released under the MIT license