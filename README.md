SlideShowPro Director API Wrapper
============

Ruby wrapper for the SlideShowPro Director API. Allows you to request album and gallery information.

Installation
------------

Include in your Gemfile:

    gem "slideshowpro"
    
Or just install it:
  
    gem install slideshowpro

This gem currently requires 'curl' - it calls it using back ticks. TODO: use curb instead so the dependency can be declared.

Usage
-----

    ssp = Slideshowpro::Director.new('http://yoururl.com/api/','your-api-key')

Get a Gallery:
    
    albums = ssp.get_gallery(gallery_id, :preview=>{:size => '123x35',:crop => 1, :quality => 90})
    albums.each do |album|
      puts album['name'] 
      puts album['id']
    end
    
Get an Album:
    
    album = ssp.get_album(album_id, {:large=>{:size => '225x350', :crop => 0, :quality => 95, :sharpening => 0}})
      album.each do |image|
    	puts image["large"]["url"]
    	puts image["thumb"]["url"]
    	puts image["thumb"]["width"]
    	puts image["thumb"]["height"]
    end
    
Caching
--------

This gem will cache the API responses if you pass in a cache object from your app.  Only tested with memcachd but should work with anything that responds to 'get' and 'set' methods.

Example:

    require 'memcached'
    @ssp.cache = Memcached.new

Enjoy!

License
-------

Slideshowpro gem is Copyright © 2010-2011 Dan Hixon. It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.