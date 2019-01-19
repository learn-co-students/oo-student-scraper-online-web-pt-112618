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
      links = profile.css(".social-icon-container a").map {|link| link["href"]}
      # or link("href").value

      links.select do |link|
        if link.include?("twitter")
          student[:twitter] = link
        elsif link.include?("linkedin")
          student[:linkedin] = link
        elsif link.include?("github")
          student[:github] = link
        elsif link.include?(".com")
          student[:blog] = link
        end
      end

      student[:profile_quote] = profile.css(".vitals-text-container .profile-quote").text
      student[:bio] = profile.css(".details-container p").text

      #finding name of href but returns array
       #profile.css(".social-icon-container //a[href*='twitter']"),
    end
    student
  end

end
