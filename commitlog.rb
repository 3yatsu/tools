#!/bin/ruby

require "rexml/document"
require 'optparse'
require 'pp'
option = Hash.new
OptionParser.new do |opt|
  opt.on('-a','--author   :search target') { |v| option[:a]=v }
  opt.on('-r','--revision :from:to') { |v| option[:r]=v }
  opt.parse!(ARGV)
end

target_author = option[:a]
revision = option[:r]

commit_log = Hash.new do |hash,key|
  hash[key]= Hash.new { |h,k| h[k]=0 }
end
  
cmd ="svn log --xml --stop-on-copy -q -v -r#{revision}"
puts cmd

doc = REXML::Document.new `#{cmd}`

REXML::XPath.each(doc, '/log/logentry') do |entry|
  if entry.get_text('author').value.match(/#{target_author}/) then
    entry.each_element('paths/path') do |path|
      action =  path.attributes.get_attribute("action").value
      text = path.get_text.value
      if (action == 'A') then
        commit_log[:added][text]+=1
      elsif (action == 'M') then
        commit_log[:modified][text]+=1 unless commit_log[:added].has_key?(text)
      else
        commit_log[:deleted][text]+=1
        commit_log[:added].delete(text)
      end
    end
  end
end

commit_log.each do |key, h|
  puts key
  h.keys.sort.each do |k|
    puts k
  end
end
