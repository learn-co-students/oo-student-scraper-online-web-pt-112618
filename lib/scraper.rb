require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    students = []
    index_page.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        student_profile_link = "#{student.attr('href')}"
        student_location = student.css('.student-location').text
        student_name = student.css('.student-name').text
        students << {name: student_name, location: student_location, profile_url: student_profile_link}
      end
    end
    students
  end
 

  def self.scrape_profile_page(profile_url)
    profile = Nokogiri::HTML(open(profile_url))
    attributes = {}
    profile.css("div.social-icon-container a").each do |link_xml|
      case link_xml.attribute("href").value
      when /twitter/
        attributes[:twitter] = link_xml.attribute("href").value
      when /github/
        attributes[:github] = link_xml.attribute("href").value
      when /linkedin/
        attributes[:linkedin] = link_xml.attribute("href").value
      else
          attributes[:blog] = link_xml.attribute("href").value
      end
    end
    attributes[:profile_quote] = profile.css("div.profile-quote").text
    attributes[:bio] = profile.css("div.bio-content div.description-holder").text.strip
    attributes
  end	

end

