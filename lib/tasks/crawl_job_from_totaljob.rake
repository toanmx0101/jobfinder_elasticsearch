#! /usr/bin/env ruby

require 'nokogiri'
require 'open-uri'


task crawl_job_from_totaljob: :environment do
  # Fetch and parse HTML document
  doc = Nokogiri::HTML(open('https://www.totaljobs.com/jobs/logistics'))

  
  # puts "### Search for nodes by css"
  # doc.css('td.first-column a.job-detail-link', 'a').each do |link|
  #   puts link.content
  # end
  file = "totaljobs.json"
  a = []
  b = []
  File.open(file, "w") do |tt_json|
    tt_json.puts '['
    doc.xpath("//div[@class='job-title']//a").each do |el|
      binding.pry
      tt_json.puts '{"title": "' + el.content + '"},'
    end
    tt_json.puts ']'
  end
  
end