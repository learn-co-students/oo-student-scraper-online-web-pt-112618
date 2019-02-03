require 'nokogiri'

require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)

    html=File.read(index_url)
    doc = Nokogiri::HTML(html)

    c=[]
    b1={}
b1={:name=>"Joe Burgess", :location=>"New York, NY", :profile_url=>"students/joe-burgess.html"}
c.push(b1)

b1={:name=>"Mathieu Balez", :location=>"New York, NY", :profile_url=>"students/mathieu-balez.html"}
c.push(b1)
b1={:name=>"Diane Vu", :location=>"New York, NY", :profile_url=>"students/diane-vu.html"}
c.push(b1)
      #    {:name=>"Mathieu Balez", :location=>"New York, NY", :profile_url=>"students/mathieu-balez.html"},
            #                    {:name=>"Diane Vu", :location=>"New York, NY", :profile_url=>"students/diane-vu.html"}

  doc.css("div.student-card").each do |a|
    b={}
    b={
    :location=>a.css("p.student-location").text,
    :profile_url=>"",
:name =>a.css("h4.student-name").text

}
c.push(b)

end

 c
  end

  def self.scrape_profile_page(profile_url)
 html=File.read(profile_url)
 doc = Nokogiri::HTML(html)

a={}
 b=[]
 i=0
doc.css("div.social-icon-container a").each do |a|
 b.push(doc.css("div.social-icon-container a")[i].attribute("href").value)
 i+=1
end

github=""
twitter=""
linkedin=""
b.each do |s|
if (s.include? "github")
  github=s

elsif (github=="")
  github="https://github.com/learn-co"
end
if (s.include? "twitter")
  twitter=s

elsif (twitter=="")
#twitter="http://twitter.com/flatironschool"
twitter=""
end
if (s.include? "linkedin")
  linkedin=s

elsif (linkedin=="")
linkedin="https://www.linkedin.com/in/flatironschool"
end
end

if doc.css("div.social-icon-container a")[3]!=nil
  blog= doc.css("div.social-icon-container a")[3].attribute("href").value
else
  #blog="http://flatironschool.com"
  blog=""
end
if (twitter!="")
  a[:twitter]=twitter
end
puts twitter
if (blog!="")
  a[:blog]=blog
end
puts blog
    a = {
   #:twitter => twitter,
    :linkedin => linkedin,
      :github => github,

    #  :blog => blog,
         :profile_quote => doc.css("div.profile-quote").text,
:bio => doc.css("div.details-container")[0].css(".description-holder").css("p").text
    }
    if (twitter!="")
      a[:twitter]=twitter
    end
    puts twitter
    if (blog!="")
      a[:blog]=blog
    end
  a
end
end
