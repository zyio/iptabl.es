require 'rubygems'
require 'sinatra'
require 'haml'

before do
   #Strip the last / from the path
        request.env['PATH_INFO'].gsub!(/\/$/, '')
    end

get '/', :agent => /curl/ do
"Still in progress, but it currently takes up to and including 5 variables.\n\n  dport\n  jumpTo\n  IP\n  protocol\n  and chain.\n\nOrder is irrelevant\n\neg: curl iptabl.es/accept/2020/192.168.0.1/output/tcp\n\nThis is pretty barebones information, seeing as you're using curl. \nHead over to iptabl.es in a browser for more indepth information. \n(may not actually be there yet)\n"
end


get '/' do
	haml :index
end


#get '/subsonic/' do
#	pass
#end

#get '/:v/:w/:x/:y/:z' do
#get '/:v?:w?:x?:y?:z?' do
get '/*' do
input = params[:splat].to_s.split('/')
=begin
a = params[:v]
b = params[:w]
c = params[:x]
d = params[:y]
e = params[:z]
=end
a = input[0]
b = input[1]
c = input[2]
d = input[3]
e = input[4]
f = input[5]

dport = ""
jumpTo = ""
ip = ""
protocol = ""
chain = ""
headless = 0

options = [a,b,c,d,e,f]

i=0

while i<6
  case options[i]
	#when options[i].to_i == (1..99999); dport = options[i]; #puts dport
	when "accept" , "drop" , "reject"; jumpTo = options[i]; #puts jumpTo
	when /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/; ip = options[i]; #puts ip
	when "tcp" , "udp"; protocol = options[i]; #puts protocol
	when "headless" ; headless = 1; #decide if headless
	end
	
	if options[i] =~ /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/
	  
	else
	  case options[i].to_i
  	when 1..99999; dport = options[i]; #puts dport
  	end
  end
	
	
	#if options[i] != /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/ && options[i].to_i === (1..99999)
	#  dport = options[i]
	#end
		
	if options[i] =~ /^[a-zA-Z]+$/ && ["reject" , "accept" , "drop", "tcp" , "udp" , "headless"].include?(options[i]) == false
     chain = options[i]
     #puts chain
  end
  i = i+1
end
#puts i


if dport != ""
  dport = " --dport "+dport
end

if jumpTo != ""
  jumpTo = " -j "+jumpTo.upcase
elsif jumpTo == ""
  jumpTo = " -j DROP"
end

if ip != ""
  ip = " -s "+ip
end

if protocol != ""
  protocol = " -p "+protocol
elsif protocol == ""
  protocol = " -p tcp"
end

if chain != ""
  chain = "-I "+chain.upcase
elsif chain == ""
  chain = "-I INPUT"
end

if headless == 1;
  "#{chain}#{protocol}#{ip}#{dport}#{jumpTo}\n"
else	
  "iptables #{chain}#{protocol}#{ip}#{dport}#{jumpTo}\n"
end

end
