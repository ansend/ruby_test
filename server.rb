#! /usr/bin/ruby -w 

require 'socket'               # 获取socket标准库

xmlfile = File.new("./config.xml") 

server = TCPServer.open(2000)  # Socket 监听端口为 2000
loop {                         # 永久运行服务
  client = server.accept       # 等待客户端连接

  xmlfile = File.new("./config.xml") 
 
  line = 1
  for i in 0..100 # firstly read out all the request from client.
      line = client.gets    # here simulate read the client request.
      if ( line =~ /<\/Message>(.*)/ || line =~ /<\/Conf>(.*)/ )
         puts "at end of the request"
      break
      end
  end
  
  while line = xmlfile.gets
      client.puts(line.chop)
  end
  client.puts(Time.now.ctime)  # 发送时间到客户端
  client.puts "Closing the connection. Bye!"

  client.close                 # 关闭客户端连接
}

