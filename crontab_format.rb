#!/usr/bin/ruby
require 'optparse'
require 'pp'
class CronLine
  attr_accessor :minute,:hour,:day,:month,:day_of_week,:name
  def initialize (minute,hour,day,month,day_of_week,name)
    @minute=minute; @hour=hour; @day=day; @month=month; @day_of_week=day_of_week; @name=name;
  end
end

class CronParser
  
  def self.parse_line(line)
    ret=[]
    e = line.split(/\s+/,6)
    time = self.separate_time(e[1])
    time.each do |t|
      ret.push(CronLine.new(e[0],t,e[2],e[3],e[4],e[5].strip))
    end
    ret
  end
  
  def self.parse(text)
    ret = []
    text.each_line do |l|
      next if l.match(/^[#\@]|^\s*$/)
      line= self.parse_line(l)
      ret = ret + self.parse_line(l)
    end
    ret.sort! { |a,b|
     a.hour.to_i == b.hour.to_i ? a.minute.to_i <=> b.minute.to_i : a.hour.to_i <=> b.hour.to_i
    }
  end

  def self.separate_time(time)
    start, limit, interval = [nil,nil,nil]
    if (m=/(\d+)-(\d+)\/(\d+)/.match(time)) then
      start, limit, interval = m.values_at(1,2,3).map{ |v| v.to_i }
    elsif (/^\d+$/.match(time)) then
      return Array(time.to_i)
    else
      return Array(time)
    end
    
    ret = []
    start.step(limit,interval) do |i|
      ret.push(i)
    end
    ret
  end
end

str=gets(nil)
puts "name\tmonth\tday\thour:minutet\tday_of_week"
cron_lines = CronParser.parse(str)
cron_lines.each do |c|
  puts "#{c.name}\t#{c.month}\t#{c.day}\t#{c.hour}:#{c.minute}\t#{c.day_of_week}"
end
