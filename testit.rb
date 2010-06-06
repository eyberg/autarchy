class SwitchProxy

  def new

File.open("/home/feydr/.mozilla/firefox/eh6yxwju.default/prefs.js") do |f| @blah = f.read end

ipfound = false
portfound = false
manfound = false

newip = "41.190.16.17"
newport = "8080"

@newconfig = []

@blah.lines.each do |line|
  rline = line

  if !line.match("network.proxy.http").nil?
    puts line
    ipfound = true
    rline = 'user_pref("network.proxy.http", "'+newip+'");'
  end

  if !line.match("network.proxy.http_port").nil?
    puts line
    portfound = true
    rline = 'user_pref("network.proxy.http_port", '+newport+');'
  end

  if !line.match("network.proxy.type").nil?
    puts line
    manfound = true
    rline = 'user_pref("network.proxy.type", 1);'
  end


  @newconfig << rline
end

if !ipfound then
  rline = 'user_pref("network.proxy.http", "'+newip+'");'
  @newconfig << rline
end

if !portfound then
  rline = 'user_pref("network.proxy.http_port", '+newport+');'
  @newconfig << rline
end

if !portfound then
  rline = 'user_pref("network.proxy.type", 1);'
  @newconfig << rline
end

File.open("/home/feydr/.mozilla/firefox/eh6yxwju.default/prefs.js", 'w') do |f| f.write(@newconfig.join) end

end
end
