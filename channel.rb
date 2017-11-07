#! /home/ansen/.rvm/rubies/ruby-2.3.3/bin/ruby -w

require 'socket'     
require 'timeout'

class Channel
    #@@ip= '192.168.56.1'
    @@ip= '10.1.3.141'
    #@@ip= '10.1.3.55'
    @@port = 20170;
    #@@ip= 'localhost'
    #@@port = 2000;
   
    
    def initialize(host="localhost", port="21003")
        @host = host
        @port = port
        @sock = nil
        @connected = false
    end
    
    #**************************************
    #para1 tout: connection timeout
    #**************************************
    def open(tout=5.5)
        puts "INFO: start to connecting to server"
        begin 
            Timeout.timeout(tout) do
                @sock = TCPSocket.open(@host, @port)
            end
        rescue Exception => e
            puts "ERROR: connection to server failed"
            puts e.message
            puts e.backtrace.inspect
            return
        end
        @connected = true
=begin

sock = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, 0)
timeval = [3, 0].pack("l_l_")
sock.setsockopt Socket::SOL_SOCKET, Socket::SO_RCVTIMEO, timeval
sock.connect( Socket.pack_sockaddr_in(1234, '127.0.0.1'))
=end

    end

    #
    #
    def setopt()
        #set socket no delay
        @sock.setsockopt Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1
        #set snd and recv timeout
        
    end
    
    #********************************************
    #para1: data: as a string.
    #********************************************
    def write(data)
        #@sock.write(data)
	puts "channel data: #{str2hex(data)}"
    end
    
    #********************************************
    #return : as a string, since ruby string is 
    #         binary safe.
    #********************************************
    def read()
        data = @sock.recv(8192)
        return data
    end

    #********************************************
    #desc: clear all data in the socket.
    #********************************************
    def clear()
        @sock.recv(65535)
    end


end

=begin
def bin2hex(binary)
    res = ""
    binary.each{|b| res = res + sprintf("%.02X", b)}
    return res
end

chnl = Channel.new("192.168.5.233", 21003)
chnl.open
while(1)  do

   byte_str = chnl.read
   bytes_array = byte_str.bytes.to_a
   puts "data recved"
   hex = bin2hex(bytes_array)
  # puts "#{hex}"
   
   #str.each_byte is equal to str.bytes
   byte_str.each_byte  do |c|
        str=sprintf("%.02X",c)
        puts "data: #{str}"
   end

end
=end
