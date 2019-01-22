require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    students = []
    index_page.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        student_name = student.css(".student-name").text
        student_location = student.css(".student-location").text
        student_profile_url = "#{student.attr("href")}"
        students << {:name => student_name, :location => student_location, :profile_url => student_profile_url}
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(open(profile_url))
    profile = {}
    urls = profile_page.css(".social-icon-container a").map {|element| element.attr("href")}
      urls.each do |url|
      case
      when url.include?("twitter")
        profile[:twitter] = url
      when url.include?("linkedin")
        profile[:linkedin] = url
      when url.include?("github")
        profile[:github] = url
      else
        profile[:blog] = url
      end
    end
    profile[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote")
    profile[:bio] = profile_page.css("div.description-holder p").text if profile_page.css("div.description-holder p")
    profile
  end
end
