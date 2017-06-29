#! /usr/bin/ruby -w

class EtcRequest

    @@ip= '10.1.5.154'
    @@port = 20170;
    #@@ip= 'localhost'
    #@@port = 2000;
    @@template_base_dir = "./request_template/normal/";
    @@output_base_dir = "./output/normal/";

    def EtcRequest.init_config(ip, port, tmp_base_dir, out_base_dir)
   
        @@ip = ip
	@@port = port
	@@template_base_dir = tmp_base_dir
	@@output_base_dir = out_base_dir
    end

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

    def run_case()
        send_packet()
	recv_packet()
	verify_result()
    end

########################################################
# start to send packet to server
########################################################
    def send_packet()
 
        puts "INFO: start to connecting to server"
        begin 
	    @sock = TCPSocket.open(@@ip, @@port)
        rescue Exception => e

            puts "ERROR: connection to server failed"
	    puts e.message
	    puts e.backtrace.inspect
	    return
	end
        puts "Info: connection established "
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

	while line = xmlfile.gets
	    @sock.puts(line.chomp)
	end

	puts "INFO: sending packet done"
    end

########################################################
# recv pcket from server and save in output file
########################################################
    def recv_packet()
        
        output = File.new("#{@outfile}", 'w+')       
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
	puts "INFO: packet recv done"
	#puts  "return 0 from the remote socket , ready to close it"
	@sock.close()
    end

    def set_ip_port(ip, port)

         @@ip = ip;
	 @@port = port;
    end
 
########################################################
# verfiy the expected the result.
########################################################
    def verify_result()

    end
end

