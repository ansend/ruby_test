#! /usr/bin/ruby -w 

$LOAD_PATH << '.'
require 'etcrequest'
require 'socket'      # Sockets 是标准库
require 'rexml/document'
require 'etcrequest'

include REXML


puts "hello world"
xmlfile = File.new("./test_conf_normal.xml")
xmldoc = Document.new(xmlfile)



=begin
 # 获取 root 元素
 root = xmldoc.root
 puts "Root element : " + root.attributes["shelf"]
  
 # 以下将输出电影标题
 xmldoc.elements.each("collection/movie"){ 
  |e| puts "Movie Title : " + e.attributes["title"] 
 }
      

# 以下将输出所有电影类型
xmldoc.elements.each("collection/movie/type") {
|e| puts "Movie Type : " + e.text 
 }
	  
  # 以下将输出所有电影描述
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
 # 打印所有电影类型
 XPath.each(xmldoc, "//type") { |e| puts e.text }
  
  # 获取所有电影格式的类型，返回数组
  names = XPath.match(xmldoc, "//format").map {|x| x.text }
  p names
=end
