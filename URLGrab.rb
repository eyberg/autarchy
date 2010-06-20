require 'rubygems'
require 'mechanize'
require 'sanitize'
require 'hpricot'

class URLGrab
  attr_accessor :urllist

  def load
    File.open(".urllist", "r") do |f| @blah = f.read end
    self.urllist = Marshal.load(@blah)
  end

  def save
    File.open(".urllist", "w") do |f| f.write(Marshal.dump(self.urllist)) end
  end

  # search google for links on keyword
  def scan(kw)
    if kw.nil? or kw.empty? then
      kw = "cats"
    end

    search = "http://google.com/search?q=#{kw}"

    a = WWW::Mechanize.new

    page = a.get(search)

    hpage = Hpricot(page.body)

    self.urllist = []
    hpage.search("//li[@class='g']/h3/a").each do |link|
      self.urllist << link.attributes["href"]
    end

  end

end
