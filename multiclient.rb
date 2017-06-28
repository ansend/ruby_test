#! /usr/bin/ruby -w
# -*- coding: UTF-8 -*-

require 'socket'

#$LOAD_PATH << '.'
require 'etcrequest'


def threadfunc()
    i = 0
    num =  100
    
    while i < num  do
        puts("在循环语句中 i = #{i}" )
	req = EtcRequest.new("config.xml", 900)
        req.start_request()
        i +=1
    end

end


for i in 0..10000
   puts "局部变量的值为 #{i}"
   t1=Thread.new{threadfunc()}
   t1.join
end

=begin
   puts "second thread"
   t2=Thread.new{threadfunc()}
   t2.join
   
   puts "third thread"
   t3=Thread.new{threadfunc()}
   t3.join
=end
