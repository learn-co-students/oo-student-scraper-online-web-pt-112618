require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    url = File.read(index_url)
    doc = Nokogiri::HTML(url)
    
    students = []
    doc.css("div.student-card").each do |student|
     
      students += [
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text, 
        :profile_url => student.css("a").attribute("href").value
        ]
    end 
    students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(File.read(profile_url))
    
    student = {}
    
    doc.css(".main-wrapper").each do |profile|
      #binding.pry
      social = profile.css(".social-icon-container a").map {|link| link["href"]} # or link("href").value
      
      if twitter_idx = social.index {|s|s.include?("twitter")}
      elsif linkedin_idx = social.index {|s|s.include?("linkedin")}
      elsif github_idx = social.index {|s|s.include?("github")}
      elsif blog_index = social.index {|s|s.include?(".com")}
      else
        nil
      end

      student = {
        :twitter => social[twitter_idx],
        :linkedin => social[linkedin_idx],
        :github => social[github_idx],
        :blog => social[blog_index],
        :profile_quote => profile.css(".vitals-text-container .profile-quote").text,
        :bio => profile.css(".details-container p").text
      }
       #profile.css(".social-icon-container //a[href*='twitter']"), -finding name of href but returns array
    end
    student.delete_if {|k,v|v.nil?}
  end

end

