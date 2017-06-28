#! /usr/bin/ruby -w 

require 'rexml/document'
include REXML

puts "hello world"
xmlfile = File.new("./config.xml")
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

# 第一个电影的信息
msgclient = XPath.first(xmldoc, "//msgclient")
p msgclient

url = XPath.first(msgclient, "//url")
p url

puts "url element : " + url.text

=begin
 # 打印所有电影类型
 XPath.each(xmldoc, "//type") { |e| puts e.text }
  
  # 获取所有电影格式的类型，返回数组
  names = XPath.match(xmldoc, "//format").map {|x| x.text }
  p names
=end
