#! /usr/bin/ruby -w 

require 'socket'      # Sockets 是标准库
 
hostname = 'localhost'
port = 2000
=begin 
s = TCPSocket.open(hostname, port)



while line = s.gets   # 从 socket 中读取每行数据
  puts line.chop      # 打印到终端
end
s.close               # 关闭 socket

=end


class EtcRequest

    @@ip= 'localhost'
    @@port = 2000;

    def initialize(file)
          #@requestfile, @height = w, h
        @requestfile = file
        @outfile = file.delete(".xml") + ".out"
	@sock = TCPSocket.open(@@ip, @@port)
    end

    def start_request()
        xmlfile = File.new("#{@requestfile}")       
        output = File.new("#{@outfile}", 'w+')       
	while line = xmlfile.gets
	    @sock.puts(line.chomp)
	end

	while line = @sock.gets
	    output.puts(line.chomp)
	    puts line
	end

	s.close()
    end

    def set_ip_port(ip, port)

         @@ip = ip;
	 @@port = port;
    end

end

req = EtcRequest.new("config.xml")
req.start_request()

