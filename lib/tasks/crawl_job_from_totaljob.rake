#! /usr/bin/env ruby

require 'nokogiri'
require 'open-uri'


task crawl_job_from_totaljob: :environment do
  # Fetch and parse HTML document
  file = "totaljobs1.json"

  File.open(file, "w") do |tt_json|
    tt_json.puts '['

    (6..10).each do |z|
      doc = Nokogiri::HTML(open('https://www.totaljobs.com/jobs/sales?page=' + z.to_s))

      file = "totaljobs.json"
      title = []
      location = []
      salary = []
      
      doc.xpath("//div[@class='job-title']//a//h2").each do |lo|
        title.push(lo.content)
      end
      doc.xpath("//li[@class='salary']").each do |sa|
        salary.push(sa.content)
      end
      doc.xpath("//li[@class='location']").each do |sa|
        location.push(sa.content.gsub("\n", '').lstrip.rstrip)
      end
      i = 0
      doc.xpath("//div[@class='job  '] | //div[@class='job new ']").each do |el|
        details = Nokogiri::HTML(open("https://www.totaljobs.com/job/" + el.attributes['id'].value ))
        description = details.xpath("//div[@class='job-description']")[0]
        tt_json.puts '{"title": "' + title[i] + '", "salary": "' + salary[i] + '", "location": "' + location[i] + '", "description":"' + description.to_html.gsub("\n", '').gsub("\r", '').gsub("\"", '\"') + '"},'
        i = i+ 1
      end
    end
    tt_json.puts ']'  
  end
  
  

end