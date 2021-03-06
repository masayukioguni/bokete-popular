#!/usr/bin/env ruby
require File.expand_path '../bootstrap', File.dirname(__FILE__)
require 'bokete'
require 'capture'
require 'tumblr'
require 'logs'

out = ARGV.shift

urls = [Bokete.popular, Bokete.hot].flatten.uniq

url = (urls - Logs.all).sample
file = Capture.make url, out do |log|
  puts log
end
unless File.exists? file
  STDERR.puts 'capture failed'
  exit 1
end
Logs.add url

puts "#{file} uploading.."
res = Tumblr.new(Conf['tumblr']['mail'], Conf['tumblr']['pass']).
  write_photo(file, Conf['tumblr']['description'].to_s+' '+url)

if res.to_i > 0
  puts "success!! => #{res}"
else
  puts "failed."
end
