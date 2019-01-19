require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    url = File.read(index_url)
    doc = Nokogiri::HTML(url)
    
    students = []
    doc.css("div.student-card").each do |student|
      #binding.pry
      students += [
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text, 
        :profile_url => student.css("a").attribute("href").value
        ]
    end 
    students
  end

  def self.scrape_profile_page(profile_url)
    url = File.read(profile_url)
    doc = Nokogiri::HTML(url)
    
    profiles = {}
    
    doc.css(".main-wrapper").each do |profile|
      binding.pry
      social = profile.css(".social-icon-container a").map {|link| link["href"]}
      
      twitter_idx =  social.index {|s|s.include?("twitter")}
      linkedin_idx =  social.index {|s|s.include?("linkedin")}
      github_idx = social.index {|s|s.include?("github")}
      
      #profile.css(".social-icon-container //a[href*='twitter']"), -finding name of href but returns array
      
      profiles = {
        :twitter => social[twitter_idx],
        :linkedin => social[linkedin_idx],
        :github => social[github_idx],
        :blog => profile.css(".social-icon-container //a[href*='youtube']"),
        :profile_quote => profile.css(".vitals-text-container .profile-quote").text,
        :bio => profile.css(".details-container p").text
      }
    end
    profiles.delete_if {|k,v|v.nil?}
  end

end

