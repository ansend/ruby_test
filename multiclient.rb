#! /usr/bin/ruby -w
# -*- coding: UTF-8 -*-

require 'socket'

$LOAD_PATH << '.'
require 'etcrequest'


def threadfunc()
    i = 0
    num =  1000000 
    
    while i < num  do
        puts("在循环语句中 i = #{i}" )
        #	req = EtcRequest.new("config.xml", 900)
        begin   
            req = BuffReadEtcRequest.new("read_A2.xml", 900)
            req.run_case()
        rescue Exception => e
                 
            puts "ERROR: run case failure, just ignore and run next "
            puts e.message
            puts e.backtrace.inspect
        end     

        i +=1
        sleep 3
    end

end


for i in 0..50
   puts "局部变量的值为 #{i}"
   t1=Thread.new{threadfunc()}
   #t1.join
end

sleep 100000000

=begin
   puts "second thread"
   t2=Thread.new{threadfunc()}
   t2.join
   
   puts "third thread"
   t3=Thread.new{threadfunc()}
   t3.join
=end
