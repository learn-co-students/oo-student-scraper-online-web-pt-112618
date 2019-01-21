require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    scraped_students = []

    doc.css(".student-card").each do |student|
      hash = {}
      hash[:name] = student.css(".student-name").text
      hash[:location] = student.css(".student-location").text
      hash[:profile_url] = student.css("a").first["href"]
      #why do you have to use ".first" to get the href? is there any other way?
      scraped_students << hash
    end
    scraped_students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))

    students_hash = {}

    doc.css(".main-wrapper").each do |elements|
      elements.css(".social-icon-container a").each do |link|
          url = link.attributes["href"].value
          if url.include?("twitter")
            students_hash[:twitter] = url
          elsif url.include?("github")
            students_hash[:github] = url
          elsif url.include?("linkedin")
            students_hash[:linkedin] = url
          else
            students_hash[:blog] = url
          end
      end

      students_hash[:bio] = doc.css(".description-holder p").text if doc.css(".description-holder p")
      students_hash[:profile_quote] = doc.css(".profile-quote").text if doc.css(".profile-quote")
    end
    students_hash
  end

end
