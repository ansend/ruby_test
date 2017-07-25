#! /usr/bin/ruby -w 

$LOAD_PATH << '.'
require 'etcrequest'
require 'socket'      # Sockets 是标准库
require 'rexml/document'
require 'etcrequest'

include REXML

puts "******start normal message test ********"
xmlfile = File.new("./test_conf_normal.xml")
xmldoc = Document.new(xmlfile)


=begin
 # get root element
 root = xmldoc.root
 puts "Root element : " + root.attributes["shelf"]
 # out put the attibutes
 xmldoc.elements.each("collection/movie"){ 
  |e| puts "Movie Title : " + e.attributes["title"] 
 }
      
# out put all the sub element
xmldoc.elements.each("collection/movie/type") {
|e| puts "Movie Type : " + e.text 
 }
	  
  # content of the element
  xmldoc.elements.each("collection/movie/description") {
     |e| puts "Movie Description : " + e.text 
}
=end

=begin
msgclient = XPath.first(xmldoc, "//msgclient")
p msgclient
url = XPath.first(msgclient, "//url")
p url
puts "url element : " + url.text
=end

ip = XPath.first(xmldoc, "//ip")
p  ip           
                
port = XPath.first(xmldoc, "//port")
p port          

dest_dir = XPath.first(xmldoc, "//dest_temp_dir")
p dest_dir

dest_out = XPath.first(xmldoc, "//dest_output_dir")
p dest_out

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

=begin
  #
  XPath.each(xmldoc, "//type") { |e| puts e.text }
  # return a array
  names = XPath.match(xmldoc, "//format").map {|x| x.text }
  p names
=end
