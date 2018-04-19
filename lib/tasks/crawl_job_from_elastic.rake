#! /usr/bin/env ruby

require 'nokogiri'
require 'open-uri'


task crawl_job: :environment do
  # Fetch and parse HTML document
  doc = Nokogiri::HTML(open('https://www.elastic.co/about/careers'))

  
  # puts "### Search for nodes by css"
  # doc.css('td.first-column a.job-detail-link', 'a').each do |link|
  #   puts link.content
  # end
  file = "/lib/assets/elas_jobs.json"
  header = "title,location"
  a = []
  b = []
  File.open(file, "w") do |e_json|
    e_json.puts '['
    doc.xpath("//tbody//tr//td//h4", "//article//td//h4").each do |el|
      a.push(el.content.lstrip.rstrip)
    end
    doc.xpath("//tbody//tr//td", "//article//td").each do |el|
      b.push(el.content.lstrip.rstrip)
    end
    c = b - a
    i = 0
    doc.xpath("//a[@class='job-detail-link']").each do |el|
      details = Nokogiri::HTML(open("https://www.elastic.co" + el.attributes['href'].value ))
      description = details.xpath("//div[@class='job-desc-hide hidden']")[0].content
      e_json.puts '{"title": "' + c[i] + '", "location": "' + c[i + 1] + '", "description": "' + description.gsub("\n", '').gsub("\"", '\"') + '"},'
      i+=2
    end
    e_json.puts ']'
  end
  
end