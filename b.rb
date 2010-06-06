require "rubygems"
require "selenium/client"

creds = {}
creds["first"] = "tom"
creds["last"] = "schwartz"
creds["postal"] = 23234
creds["birth_day"] = 23
creds["birth_year"] = 1979

@browser = Selenium::Client::Driver.new \
      :host => "localhost",
      :port => 4444,
      :browser => "*firefox",
      :url => "http://google.com",
      :timeout_in_second => 60

@browser.start_new_browser_session

@browser.open "http://google.com"
=begin
# yahoo email signup
@browser.open "https://edit.yahoo.com/registration?.src=fpctx&.intl=us&.done=http://www.yahoo.com/"
@browser.type "firstname", creds["first"]
@browser.type "secondname", creds["last"]
@browser.type "dd", creds["birth_day"]
@browser.type "yyyy", creds["birth_year"]
=end

#@browser.click "btnG", :wait_for => :page
