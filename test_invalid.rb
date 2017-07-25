#! /usr/bin/ruby -w 

$LOAD_PATH << '.'
require 'etcrequest'
require 'socket'      # Sockets 是标准库
require 'rexml/document'
require 'etcrequest'

include REXML


puts "start invalid message test"
xmlfile = File.new("./test_conf_invalid.xml")
xmldoc = Document.new(xmlfile)

ip = XPath.first(xmldoc, "//ip")
port = XPath.first(xmldoc, "//port")
dest_dir = XPath.first(xmldoc, "//dest_temp_dir")
dest_out = XPath.first(xmldoc, "//dest_output_dir")

puts "ip :" + ip.text
puts "port:" + port.text
puts "dest template dir :" + dest_dir.text
puts "dest output dir  : " + dest_out.text

EtcRequest.init_config(ip.text, port.text.to_i, dest_dir.text, dest_out.text)

EtcRequest.print_config()

#***************************************************************
xmldoc.elements.each("conf/testcases/case"){ 
  |e| puts "case file : " + e.attributes["file"] 
      puts "case exptcode:" + e.attributes["exptcode"]
      
      file = e.attributes["file"]
      exptcode = e.attributes["exptcode"]

      #req = EtcRequest.new(file, exptcode)
      req = BuffReadEtcRequest.new(file, exptcode)
      #req = EtcRequest.new("CMakeLists.txt", 900)
      #req = FragSendEtcRequest.new("read_A1.xml", 900)
      req.run_case()
}
#**************************************************************

