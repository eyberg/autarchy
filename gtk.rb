#!/usr/bin/env ruby

require 'gtk2'
require 'rubygems'
require "watir-webdriver"

require 'SwitchProxy.rb'
require 'ProxyGrab.rb'
require 'URLGrab.rb'

def loadurllist
  dest_model = Gtk::ListStore.new(String, String)
  dest_view = Gtk::TreeView.new(dest_model)
  dest_column = Gtk::TreeViewColumn.new("URL",
                      Gtk::CellRendererText.new,
                      :text => 0)
  dest_column.max_width = 500
  dest_column.resizable = true
  dest_column.clickable = true

  pr_column = Gtk::TreeViewColumn.new("PageRank",
                         Gtk::CellRendererText.new,
                         :text => 1)
  pr_column.resizable = true
  pr_column.clickable = true

  dest_view.append_column(dest_column)
  dest_view.append_column(pr_column)

  @ug.urllist.each do |url|
      iter = dest_model.append
      iter[0] = url
      iter[1] = "1"
  end

  @kwsearch = Gtk::Button.new("Search")
  @kwsearch.set_size_request 30, 30

  keywordEntry = Gtk::Entry.new

  @kwsearch.signal_connect("clicked") {
    @ug.scan(keywordEntry.text)
    loadurllist
  }

  @vbox.pack_start @kwsearch, false, false, 0
  @vbox.pack_start keywordEntry, false, false, 0

  view = Gtk::ScrolledWindow.new.add(dest_view)
  @vbox.pack_end view, true, true, 0

  @window.show_all

end

def loadKeyWordSearch
  dest_model = Gtk::ListStore.new(String, String)
  dest_view = Gtk::TreeView.new(dest_model)
  dest_column = Gtk::TreeViewColumn.new("URL",
                      Gtk::CellRendererText.new,
                      :text => 0)
  dest_column.max_width = 500
  dest_column.resizable = true
  dest_column.clickable = true

  pr_column = Gtk::TreeViewColumn.new("PageRank",
                         Gtk::CellRendererText.new,
                         :text => 1)
  pr_column.resizable = true
  pr_column.clickable = true

  dest_view.append_column(dest_column)
  dest_view.append_column(pr_column)

=begin
  @ug.urllist.each do |url|
      iter = dest_model.append
      iter[0] = url
      iter[1] = "1"
  end
=end

  @kwsearch = Gtk::Button.new("Search")
  @kwsearch.set_size_request 30, 30

  keywordEntry = Gtk::Entry.new

  @kwsearch.signal_connect("clicked") {
    @ug.scan(keywordEntry.text)
    loadurllist
  }

  @vbox.pack_start @kwsearch, false, false, 0
  @vbox.pack_start keywordEntry, false, false, 0

  view = Gtk::ScrolledWindow.new.add(dest_view)
  @vbox.pack_end view, true, true, 0

  @window.show_all

end

def loadproxylist
  dest_model = Gtk::ListStore.new(String, String)
  dest_view = Gtk::TreeView.new(dest_model)
  dest_column = Gtk::TreeViewColumn.new("Destination",
                      Gtk::CellRendererText.new,
                      :text => 0)
  dest_view.append_column(dest_column)
  country_column = Gtk::TreeViewColumn.new("Country",
                         Gtk::CellRendererText.new,
                         :text => 1)
  dest_view.append_column(country_column)

  @pg.goodproxies.each do |proxy|
      iter = dest_model.append
      iter[0] = proxy.ip
      iter[1] = proxy.port
  end

  @vbox.pack_start Gtk::Entry.new, false, false, 0
        
  @vbox.pack_end dest_view, true, true, 0

  @window.show_all

end

@window = Gtk::Window.new
@window.set_title("ez site exploder")

@pg = ProxyGrab.new
@ug = URLGrab.new

holdbox = Gtk::VBox.new(false, 2)
butbox = Gtk::HBox.new(false, 2)

button = Gtk::Button.new("register browser")
proxyscrape = Gtk::Button.new("scrape proxies")
loadproxies = Gtk::Button.new("load proxies")
saveproxies = Gtk::Button.new("save proxies")

urlscrape = Gtk::Button.new("scrape urls")
loadurls = Gtk::Button.new("load urls")
saveurls = Gtk::Button.new("save urls")

button.set_size_request 100, 10
proxyscrape.set_size_request 100, 0
loadproxies.set_size_request 100, 0
saveproxies.set_size_request 100, 0

urlscrape.set_size_request 100, 30
loadurls.set_size_request 100, 30
saveurls.set_size_request 100, 30

button.signal_connect("clicked") {
  sp = SwitchProxy.new
  browser = Watir::Browser.new(:firefox)
  browser.execute_script("alert('test');")
#browser = Watir::Browser.new(:chrome) #initialize(:chrome, "--proxy-server=41.190.16.17:8080")
  browser.goto("http://whatismyip.com")
}



loadproxies.signal_connect("clicked") {
  @pg.load
  loadproxylist
}

loadurls.signal_connect("clicked") {
  @ug.load
  loadurllist
}

saveproxies.signal_connect("clicked") {
  @pg.save
}

saveurls.signal_connect("clicked") {
  @ug.save
}

proxyscrape.signal_connect("clicked") {
  @pg.scan
  loadproxylist
}

urlscrape.signal_connect("clicked") {
  #@ug.scan
  loadKeyWordSearch
}

@window.signal_connect("delete_event") {
  puts "delete event occurred"
  false
}

@window.signal_connect("destroy") {
  puts "destroy event occurred"
  Gtk.main_quit
}

mb = Gtk::MenuBar.new

filemenu = Gtk::Menu.new
filem = Gtk::MenuItem.new "File"
filem.set_submenu filemenu

exit = Gtk::MenuItem.new "Exit"
exit.signal_connect "activate" do
  Gtk.main_quit
end

filemenu.append exit

mb.append filem

@vbox = Gtk::VBox.new false, 2
holdbox.pack_start mb, false, false, 0

butbox.pack_start button, false, true, 0
butbox.pack_start proxyscrape, false, true, 0
butbox.pack_start loadproxies, false, true, 0
butbox.pack_start urlscrape, false, true, 0
butbox.pack_start loadurls, false, true, 0
butbox.pack_start saveproxies, false, true, 0
butbox.pack_start saveurls, false, true, 0

@window.set_default_size 500, 600
@window.add holdbox
holdbox.add butbox
holdbox.add @vbox

@window.border_width = 10
@window.show_all

Gtk.main
