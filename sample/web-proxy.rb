#!/usr/local/bin/ruby 
require 'webrick/httpproxy' 
s = WEBrick::HTTPProxyServer.new( 
  :Port => 2020, 
  :RequestCallback => Proc.new{|req,res| 
    puts "-"*70 
    puts req.request_line, req.raw_header 
    puts "-"*70 
  } 
) 
trap("INT"){ s.shutdown } 
s.start
