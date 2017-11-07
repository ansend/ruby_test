#! /home/ansen/.rvm/rubies/ruby-2.3.3/bin/ruby -w

$LOAD_PATH << '.'

require 'socket'     
require 'timeout'
require 'channel'
require 'util'

PACK_SIZE            = 1024
BUFF_SIZE            = 128
UPGRADE_TIMEOUT      =  
class Upgrader	
    #@@ip= '192.168.56.1'
    @@ip= '10.1.3.141'
    #@@ip= '10.1.3.55'
    @@port = 20170;
    #@@ip= 'localhost'
    #@@port = 2000;
   
    
    def initialize(file_path, channel)
        @file_path = file_path
        @channel = channel
        @bin_file_hanle = nil
	@seq_num = 1
	@send_file_done = false
        @upgrade_done = false
        @upgrade_result = ""
    end
    
    #**************************************
    #desc: open binary file
    #**************************************
    def open_file()
        puts "INFO: open bianry file: #{@file_path}"
        begin 
            @bin_file_handle = File.open(@file_path, "rb")
	    file_size = @bin_file_handle.size
	    puts "INFO: file size: #{file_size}"
	    @total_frame_num = (file_size + BUFF_SIZE - 1) / BUFF_SIZE # total frame number to send.
        rescue Exception => e
            puts "ERROR: open binary file failed ansen dong"
            puts e.message
            puts e.backtrace.inspect
            return
        end
        @file_opend = true
    end
    #**************************************************
    #desc: convert "ff" to "ffff"
    #**************************************************
    def convert_ff(buff)

        buff_new = Array.new
        #convert 0xFF to 0xFFFF
	buff.each do |c|
            buff_new << c
            if(c == 0xFF)
               buff_new << 0xFF
            end
        end

	return buff_new
    end

    def upgrade()
        puts "INFO: start to upgrade"
        @channel.clear()
        send_preamble() 
        while(!@upgrade_done) do
        
            send_pack();
=begin
            res = channel.read();
            res_array = res.bytes.to_a
            if(res_array[0] != 0x06)
                puts "ERROR: RSU does not response 0x06 , upgrade stop!!!"
                @upgrade_result = "faile due to RSU not response 0x06"
                return
            end
=end
        end

    end 

    def send_preamble()
        sleep(1);
        @channel.write(hex2str("64"));
        sleep(0.5);
        @channel.write(hex2str("fffd00"));
        sleep(0.5);
        @channel.write(hex2str("fffb00"));
    end

    def send_pack()
        puts "INFO: start to send a pack"
        begin 
	    
            buff = Array.new 
	    index = 0

	    # fullfill frame header byte0: seq fixed 0x01, byte1: increased seq num, byte2: xor value
	    buff << 0x01  # 
	    seq =  @seq_num % 256
	    @seq_num += 1
	    buff << seq
            xor = seq ^ 0xFF
	    buff << xor
	    
            data = @bin_file_handle.sysread(BUFF_SIZE)
	    #puts "data is nil #{data}"
	    # the bin file creator has make sure the file size can be divided by 128.
	    if(data) # data is not empty

                len = data.length
		data.each_byte do |c|
              
	            buff << c
		    #convert 0xFF to 0xFFFF
                    #if(c == 0xFF)
		    #   buff << 0xFF
                    #end
                end

		# a little bit tricky, the last read len could be less then buff. full fill it to 0x1A.
		if(len < BUFF_SIZE)
                    for i in 0..BUFF_SIZE - len -1 do
                        buff << 0x1A
		    end
		end

		frame_data = buff[3, buff.length-3]
		
		isum = 0;
		frame_data.each{ |c| isum += c}
		#full fill the check sum value in last
		buff << isum % 256


                buff = convert_ff(buff)

                hex = bin2hex(buff)
                puts "seq num:#{@seq_num}, data:#{hex}"
 

		#bytes array change to string before send.
		@channel.write(bytes2str(buff)) 
	       
	        #here if last read is less BUFF_SIZE, means file sending done.	
		if(len < BUFF_SIZE)
                    @channel.write(hex2str("04"))
                    @bin_file_handle.close
                    @upgrade_done = true
                    @upgrade_result = "upgrade success"
		end

            else

                #EOF
		@channel.write(hex2str("04"))
                @bin_file_handle.close
                @upgrade_done = true
                @upgrade_result = "upgrade success"

            end
 
        rescue EOFError  => eof
	    puts "INFO: reach of of file, sending file done"
            @upgrade_done = true
            @channel.write(hex2str("04"))
            @bin_file_handle.close
            @upgrade_result = "upgrade success"

	rescue Exception => e
            puts "ERROR: read bianry file exception"
	    puts e.class
            puts e.message
            puts e.backtrace.inspect
            return
        end 


    end

end


chnl = Channel.new("192.168.5.233", 21003)
chnl.open
upder = Upgrader.new("SHINE-P30_RSU3221_M_TongYong_V1.0.3.bin", chnl)
upder.open_file()
upder.upgrade()
