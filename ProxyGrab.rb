require 'rubygems'
require 'mechanize'
require 'sanitize'
require 'hpricot'

require 'Proxy.rb'

class ProxyGrab
  attr_accessor :goodproxies

  def scan
    proxylist = "http://checkedproxylists.com/"

    a = WWW::Mechanize.new

    page = a.get(proxylist)

    fullList = ""

    page.links.each do |link|
      if link.text.eql? "full proxy list" then
        fullList = link.href
        break
      end
    end

    lurl = proxylist + "load_" + fullList

    page = a.get(lurl)

    rpage = CGI.unescapeHTML(page.body)

    hpage = Hpricot.parse(rpage)

    plist = hpage.at("//root/quote").children

    self.goodproxies = []
    plist.each do |proxy|
      ipport = Sanitize.clean(proxy.innerHTML.gsub("<\/span>",":"))
      p = Proxy.new
      p.ip, p.port = ipport.split(":")
      self.goodproxies << p
    end

  end

end
