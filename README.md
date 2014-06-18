Kaltura_Fu
----------
**Homepage**: [http://www.velir.com](http://www.velir.com)
**Author**: [Patrick Robertson](mailto:patrick.robertson@velir.com)
**Copyright**: 2010
**License**: [MIT License](file:MIT-LICENSE)

About Kaltura
-------------
[Kaltura](http://kaltura.org/) is an open source video streaming service.

About Kaltura_Fu
----------------

Kaltura_Fu is a gem that wraps the Kaltura-Ruby API wrapper and also adds some convenience methods for Rails'
ActionView.  The intent of this library is to provide a far easier means to communicate with your Kaltura server.
It's just too much of a pain to update simple things like the metadata fields with the default kaltura-ruby client.

Installation:
-------------
Install the gem with the command:

    # Gemfile
    gem "kaltura_fu", github: "tinkerbox/kaltura_fu"
Run:

    rails g kaltura_fu:install

This will install the `kaltura_fu.rb` file into your application's config/initializers directory and the `kaltura_upload.js` into the application's public/javascripts directory.

Configuration:
--------------
Obtain your Kaltura API publisher credentials via the [KMC Integration Settings](http://www.kaltura.com/index.php/kmc/kmc4#account|integration)

And update `config/initializers/kaltura_fu.rb` accordingly.

Testing:
--------

**Testing is not working currently**

The Kaltura_Fu library is being tested against the following version of Ruby:

* 1.8.7(MRI)
* 1.8.7(EE)
* 1.9.2(YARV)
* Rubinius

In order to test this gem (for local development), you'll need to have access to a Kaltura server.
I use a local installation of KalturaCE.  You'll have to add a config file under spec/config/kaltura.yml and
add in a small video file named video.flv in the same folder.  Since Kaltura provides no testing in kaltura-ruby,
I tend to use this library as a test suite for fixes for that library as well.


Documentation:
--------------
The full documentation is located [here](http://rdoc.info/github/Velir/kaltura_fu/).

Copyright (c) 2010 [Velir Studios](http://www.velir.com), released under the MIT license
