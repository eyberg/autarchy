#!/usr/bin/env ruby

require 'gtk2'
require 'rubygems'
require "watir-webdriver"
require 'testit.rb'

require 'ProxyGrab.rb'

window = Gtk::Window.new
window.set_title("ez site exploder")

hbox = Gtk::HBox.new(false, 0)

button = Gtk::Button.new("register browser")
proxyscrape = Gtk::Button.new("scrape proxies")

button.signal_connect("clicked") {
  sp = SwitchProxy.new
  browser = Watir::Browser.new(:firefox)
  browser.execute_script("alert('test');")
#browser = Watir::Browser.new(:chrome) #initialize(:chrome, "--proxy-server=41.190.16.17:8080")
  browser.goto("http://whatismyip.com")
  #puts "Hello World"
}

proxyscrape.signal_connect("clicked") {
  pg = ProxyGrab.new
  pg.scan

  # make listbox
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

  pg.goodproxies.each do |proxy|
      iter = dest_model.append
      iter[0] = proxy.ip
      iter[1] = proxy.port
  end

  @vbox.pack_start Gtk::Entry.new, false, false, 0
        
  @vbox.pack_end dest_view, true, true, 0

  window.show_all

  puts 'your mom'
}

window.signal_connect("delete_event") {
  puts "delete event occurred"
  false
}

window.signal_connect("destroy") {
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

window.add @vbox
window.border_width = 10
window.show_all

Gtk.main
