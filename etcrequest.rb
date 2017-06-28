#! /usr/bin/ruby -w

class EtcRequest

    @@ip= 'localhost'
    @@port = 2000;

    def initialize(file, code)
        #@requestfile, @height = w, h
        @requestfile = file
        @outfile = file.delete(".xml") + ".out"
	@expectcode = code  # expect response code , 900~999
	#@sock = TCPSocket.open(@@ip, @@port)
        @sock = nil
    end

    def start_request()
 
        begin 
	    @sock = TCPSocket.open(@@ip, @@port)
        rescue Exception => e

            puts "ERROR: connection to server failed"
	    puts e.message
	    puts e.backtrace.inspect
	    return
	end

        begin
            xmlfile = File.new("#{@requestfile}")       
            if xmlfile
	       puts "open file : " + "#{@requestfile}" + "sucessfullly"
	    end
	rescue Exception => e
	    puts "ERROR: not existing request file: " + "#{@requestfile}";
	    puts e.message
	    puts e.backtrace.inspect
	    return
	end
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
 
    def verify_result()


    end
end

