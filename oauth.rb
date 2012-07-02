%w(rubygems sinatra net/https).each { |lib| require lib }

enable :sessions

get '/' do
  erb :index, :layout => :application
end

get "/lookup" do
  
  begin
    uri = URI.parse(params["q"])
    http = Net::HTTP.new(uri.host,uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.start do |h|
      @cert = h.peer_cert
    end

    @names = '<br /><table class="table table-striped table-bordered">'
    @names << "<tr><td>Subject</td><td>#{@cert.subject}</td></tr>" #rescue ""
    @names << "<tr><td>Issuer</td><td>#{@cert.issuer}</td></tr>" rescue ""
    @names << "<tr><td>Serial</td><td>#{@cert.serial}</td></tr>" rescue ""
    @names << "<tr><td>Issued</td><td>#{@cert.not_before}</td></tr>" rescue ""
    @names << "<tr><td>Expires</td><td>#{@cert.not_after}</td></tr>" rescue ""
    @names << "</table>"

  rescue
    @names = "No SSL certificate found."
  end
  puts @names
  @names
  
end



