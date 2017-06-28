#! /usr/bin/ruby -w 
# -*- coding: UTF-8 -*-

require 'socket'      # Sockets 是标准库

$LOAD_PATH << '.'
require 'etcrequest'

hostname = 'localhost'
port = 2000
=begin 
s = TCPSocket.open(hostname, port)

while line = s.gets   # 从 socket 中读取每行数据
  puts line.chop      # 打印到终端
end
s.close               # 关闭 socket

=end

req = EtcRequest.new("read_A1.xml", 900)
req.start_request()

