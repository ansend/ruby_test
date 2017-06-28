#! /usr/bin/ruby -w

class EtcRequest

    @@ip= 'localhost'
    @@port = 2000;
    @@template_base_dir = "./request_template/normal/";
    @@output_base_dir = "./output/normal/";

    def initialize(file, expcode)
	@requestfile = file
        @outfile = file.delete(".xml") + ".out"

	@requestfile = "#{@@template_base_dir}" +  @requestfile
	puts @requestfile

	@outfile = @@output_base_dir +  @outfile
	puts @outfile
	@expect_code = expcode  # expect response code , 900~999
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
     
        begin 
            while line = @sock.gets
    	    output.puts(line.chomp)
    	    puts line
    	    end
        rescue Exception =>e
	    puts "ERROR: read socket error : " + "#{@requestfile}"; #in some case it will encounter conn reset by peer exp.
            puts e.message
	    puts e.backtrace.inspect
	    @sock.close()
	    return 
        end 
	
	puts  "return 0 from the remote socket , ready to close it"
	@sock.close()
    end

    def set_ip_port(ip, port)

         @@ip = ip;
	 @@port = port;
    end
 
    def verify_result()

    end
end

