require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    students = []
    doc.css(".roster-cards-container").each do |e|
      e.css(".student-card a").each do |student|
        student_profile_link = "#{student.attr('href')}"
        student_name = student.css(".student-name").text
        student_location = student.css(".student-location").text
        students << {name: student_name, location: student_location, profile_url: student_profile_link}
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    student = {}
    # doc.css(".social-icon-container").children.css("a")[0].attributes["href"].value
    links = doc.css(".social-icon-container").children.css("a").collect {|e| e.attributes["href"].value}
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
    # binding.pry
    student[:profile_quote] = doc.css(".profile-quote").text
    student[:bio] = doc.css(".description-holder p").text
    student
  end

end

