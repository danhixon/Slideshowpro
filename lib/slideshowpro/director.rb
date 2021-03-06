module Slideshowpro
	class Director
		attr_accessor :api_key, :url, :cache

		def initialize(url, api_key, cache=nil)
			self.url = url
			self.api_key = api_key
			self.cache = cache
		end

		def post(method, options)
			params = {
				'data[api_key]'=>self.api_key, 
				'data[breaker]'=>'true', 
				'data[format]'=>'json'
			}
			params.merge!(options)
			data = URI.escape(params.map {|k,v| "#{URI.escape(k)}=#{URI.escape(v.to_s)}"}.join("&"))
		
			if defined?(self.cache) && self.cache.respond_to?(:get)
				require 'digest/md5'
				data_key = Digest::MD5.hexdigest(method + "|" + data)
				begin
				if json=self.cache.get(data_key)
					return json
				else
					json = get_json(url, method, data)
					self.cache.set(data_key, json)
				end
				rescue 
					json = get_json(url, method, data)
					#self.cache.set(data_key, json)
				end
			else
				json = get_json(url, method, data)
			end
			return json
		end
		
		def get_album(album_id, formats={})
			defaults = { 
										:thumb => { :size => '41x41', :quality => 85}, 
										:retina_thumb => { :size => '82x82', :quality => 90}, 
										:large => { :crop =>0, :size=> '750x750', :sharpening => 0 }, 
										:retina=> { :crop => 0, :size => '1500x1500', :sharpening => 0 } 
									}
			formats = defaults.merge(formats)
			raw = post('get_album', format_hash(formats).merge('data[album_id]'=>album_id))
			raw["data"]["contents"]
		end

		def get_gallery(gallery_id, formats={})
			defaults = {:preview=>{:size => '123x35',:crop => 1, :quality => 90}}
			formats = defaults.merge(formats)
			raw = post('get_gallery', format_hash(formats).merge('data[gallery_id]'=>gallery_id))
			raw["data"]["albums"]
		end

		def format_hash(formats)
			default_format_params = {:crop=>1, :quality=>'90', :sharpening=>1}
			r = {}
			formats.each do |name, format|
				f = default_format_params.merge(format)
				if name==:preview
					r["data[preview]"] = "#{f[:size].gsub('x',',')},#{f[:crop]},#{f[:quality]},#{f[:sharpening]}"
				else
					r["data[size][#{name}]"] = "#{name},#{f[:size].gsub('x',',')},#{f[:crop]},#{f[:quality]},#{f[:sharpening]}"
				end
			end
			r
		end

		protected

		def get_json(url, method, data)
			puts "requesting #{url+method} with #{data.inspect}" if $debug
			response = `curl --silent #{url+method} --data "#{data}"`
			puts "recieved: #{response}" if $debug
			JSON.parse(response)
		end
	end
end