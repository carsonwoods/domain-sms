require 'rubygems'
require 'twilio-ruby'
require 'date'
require 'nokogiri'
require 'open-uri'

account_sid = '' #Your Twilio SID Here
auth_token = '' #Your Autho Token Here
to = "+11234567890" #Your Number to recieve notifications
from = "+11234567890" #Your Twilio Number

@client = Twilio::REST::Client.new account_sid, auth_token

#NameCheap Domain Information and Varaibles
domain_name = "example.com" #Desired Domain Here
is_available = false
price = 0
value = "#{domain_name} is available."

#Loop Control Variables Based On a Daily Timer
old_date = Date.today.jd
curre_date = Date.today.jd + 1
has_sent = false;

while true

  #Uses Julian Date to Only Request Domain Information once per day
  if current_date > old_date
    old_date = current_date

    #checks availability of domain and parses it using the nokogiri framework
    #please modify the namecheap API call to include your own API key and Domain to query
    doc = Nokogiri::XML(open("https://api.namecheap.com/xml.response?ApiUser=apiexample&ApiKey=56b4c87ef4fd49cb96d915c0db68194&UserName=apiexample&Command=namecheap.domains.check&ClientIp=192.168.1.109&DomainList=carson.io"))

    puts doc.at_css("ApiResponse Server")

    if doc.at_css("ApiResponse CommandResponse DomainCheckResult").to_s == "<DomainCheckResult Domain=\"carson.io\" Available=\"true\" />"
      is_available = true
    end

    #If the domain is available and a text has not been sent already then it notifies the user
    if (is_available) && (has_sent == false)
      @client.account.messages.create({
        :from => from, #Twilio Number Here
        :to => to, #Phone Number To Recieve Notifications Here
        :body => value,
      })
      has_sent = true
    end
  end
  #Makes Sure that current date value is updated
  current_date = Date.today.jd
end
