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
  dest_column = Gtk::TreeViewColumn.new("Destination",
                      Gtk::CellRendererText.new,
                      :text => 0)
  dest_column.max_width = 300
  dest_view.append_column(dest_column)
  country_column = Gtk::TreeViewColumn.new("Country",
                         Gtk::CellRendererText.new,
                         :text => 1)
  dest_view.append_column(country_column)

  @ug.urllist.each do |url|
      iter = dest_model.append
      iter[0] = url
      iter[1] = "1"
  end

  dest_view.set_fixed_height = 400

  scroller = Gtk::ScrolledWindow.new
  scroller.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_AUTOMATIC)
  @vbox.pack_start scroller, true, true, 0

  @vbox.pack_start Gtk::Entry.new, false, false, 0
        
  @vbox.pack_end dest_view, true, true, 0

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

  puts 'your mom'
end

@window = Gtk::Window.new
@window.set_title("ez site exploder")

@pg = ProxyGrab.new
@ug = URLGrab.new

hbox = Gtk::HBox.new(false, 0)

button = Gtk::Button.new("register browser")
proxyscrape = Gtk::Button.new("scrape proxies")
loadproxies = Gtk::Button.new("load proxies")
saveproxies = Gtk::Button.new("save proxies")

urlscrape = Gtk::Button.new("scrape urls")
loadurls = Gtk::Button.new("load urls")
saveurls = Gtk::Button.new("save urls")

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

proxyscrape.signal_connect("clicked") {
  @pg.scan
  loadproxylist
}

urlscrape.signal_connect("clicked") {
  @ug.scan
  loadurllist
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
@vbox.pack_start mb, false, false, 0

@vbox.pack_start button, true, true, 0
@vbox.pack_start proxyscrape, true, true, 0
@vbox.pack_start loadproxies, true, true, 0
@vbox.pack_start urlscrape, true, true, 0
@vbox.pack_start loadurls, true, true, 0
@vbox.pack_start saveproxies, true, true, 0

@window.add @vbox
@window.border_width = 10
@window.show_all

Gtk.main
