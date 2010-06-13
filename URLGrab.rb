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
    File.open(".urllist", "w") do |f| f.write(Marshal.dump(self.goodproxies)) end
  end

  def scan
    keyword = "dogs"
    search = "http://google.com/search?q=#{keyword}"

    a = WWW::Mechanize.new

    page = a.get(search)

    fullList = ""

    self.urllist = []
    page.links.each do |link|
      self.urllist << link.href
    end

  end

end
