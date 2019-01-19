require 'open-uri'
require 'nokogiri'
require 'pry'
 
class Scraper
 
  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    html_scrape = Nokogiri::HTML(html)
    html_scrape.css(".student-card").map do |student|
      {name: student.css("a .student-name").text, location: student.css("a .student-location").text, profile_url: student.css("a").attribute("href").value}
    end
  end
 
  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    html_scrape = Nokogiri::HTML(html)
    return_hash = {}
    html_scrape.css(".social-icon-container a").each do |social|
      link = social.attribute("href").value
      if link.include?("twitter")
        return_hash[:twitter] = link
      elsif link.include?("linkedin")
        return_hash[:linkedin] = link
      elsif link.include?("github")
        return_hash[:github] = link
      else
        return_hash[:blog] = link
      end
    end
    return_hash[:profile_quote] = html_scrape.css(".vitals-text-container .profile-quote").text
    return_hash[:bio] = html_scrape.css(".bio-content .description-holder p").text
    return_hash
  end
 
end