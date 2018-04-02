class UrlParser
  def initialize(url)
    @url = url
  end

  def scheme
    @url.split('://').first
  end

  def domain
    dom = @url.split('://')[1]
    if dom.include?('/') 
      dom = dom.split('/')[0]
      if dom.include?(':') 
        dom = dom.split(':')[0]
      end
    end
    dom
  end

  def port
    regex = /\:\d+/
    regex1 = /\d+/
    if @url[regex]
      @url[regex][regex1]
    else 
      if @url.split('://')[0] == "http"
        "80"
      else
        "443"
      end
    end
  end

  def path
    dom = @url.split('://')[1]
    if dom.include?('/') 
      len = dom.split('/').length() - 1
      mypath = ''
      (1..len).each do |n|
        mypath += '/' + dom.split('/')[n]
      end 
      if mypath.include?('?')
        mypath.scan(/\/(..*)\?/).flatten[0]
      else
        if mypath.include?('#')
          mypath.scan(/\/(..*)#/).flatten[0]
        else 
          mypath
        end
      end
    else
      dom.split('/')[1]
    end
  end

  def query_string
    qs_string = ''
    if @url.split('?')[1]
      qs_string = @url.split('?')[1].scan(/(.*)#/).concat(@url.split('?')[1].scan(/\?(.*)\z/)).flatten[0]
      if !qs_string.empty?
        qs_array = qs_string.split('&')
        query_s = []
        q = []
        qs_array.each do |part|
          q << part.split('=')[0] 
          q << part.split('=')[1]
          query_s << q
          q = []
        end
        Hash[query_s.map {|key,value| [key,value]}]
      end
    else 
      @url.split('?')[1]
    end
  end

  def fragment_id
    if @url[/#(.*)\z/]
      @url[/#(.*)\z/][/[^#](.*)\z/]
    end
  end

end

#GITHUB HOMEWORK!!!

# @new_url = UrlParser.new('https://ruby-doc.org/core-2.4.1/String.html#method-i-include-3F')
# @new_url = UrlParser.new('http://www.google.com:60/search?q=cat&name=Tim#img=FunnyCat')
#puts "Full URL: http://www.google.com:60/search?q=cat&name=Tim#img=FunnyCat"
# p @new_url.scheme
# p @new_url.domain
# p @new_url.port
# p @new_url.path
# p @new_url.query_string
# p @new_url.fragment_id

# @new_url_1 = UrlParser.new('https://www.google.com/?q=cat#img=FunnyCat')
# #puts "Full URL: https://www.google.com/?q=cat#img=FunnyCat"
# p @new_url_1.scheme
# p @new_url_1.domain
# p @new_url_1.port
# p @new_url_1.path
# p @new_url_1.query_string
# p @new_url_1.fragment_id

# @new_url_2 = UrlParser.new('http://www.google.com/search')
# #puts "Full URL: http://www.google.com/search"
# p @new_url_2.scheme
# p @new_url_2.domain
# p @new_url_2.port
# p @new_url_2.path
# p @new_url_2.query_string
# p @new_url_2.fragment_id