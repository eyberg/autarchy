# works with firefox and chrome!!!
require "rubygems"
require "watir-webdriver"
browser = Watir::Browser.new(:chrome)
browser.goto("http://amazon.com")
