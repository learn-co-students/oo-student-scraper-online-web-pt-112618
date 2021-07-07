require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url) #this is reading the file before I pass it into Nokogiri
    doc = Nokogiri::HTML(html)

    students = []
    doc.css("div.student-card").each do |student|
      students << {:name => student.css("h4.student-name").text,
      :location => student.css("p.student-location").text,
      :profile_url => student.css("a").attribute("href").value}
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    html = File.read(profile_url)
    profile = Nokogiri::HTML(html)
#binding.pry
    links = profile.css(".social-icon-container").children.css("a").map { |one| one.attribute('href').value}
    links.each do |link|
      if link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      else
        student[:blog] = link
      end
    end
    student[:profile_quote] = profile.css("div.profile-quote").text if profile.css("div.profile-quote")
    student[:bio] = profile.css("div.bio-content.content-holder div.description-holder p").text if profile.css("div.description-holder")
#have to put p at the end to get rid of the \n because it doesnt get the full string!
    student
#blogurl:
#profilequote: profile.css("div.profile-quote").text
#bio: profile.css("div.description-holder").text
#github:
#linkedin:
#profile_quote:
#twitter:
  end

end
# Scraper.scrape_profile_page('./fixtures/student-site/students/joe-burgess.html')

 #binding.pry
 #student = doc.css("div.student-card")
 #name: student.css("h4.student-name").text
 #location: student.css("p.student-location").text
 #profile url: student.css("a").attribute("href").value
