#! /usr/bin/env ruby

require 'nokogiri'
require 'open-uri'


task crawl_job_from_totaljob10: :environment do
  # Fetch and parse HTML document
  file = "totaljobs10.json"

  File.open(file, "w") do |tt_json|
    tt_json.puts '['

    # 5.times do |z|
    #   doc = Nokogiri::HTML(open('https://www.totaljobs.com/jobs/logistics?page=' + z.to_s))

    #   file = "totaljobs.json"
    #   title = []
    #   location = []
    #   salary = []
      
    #   doc.xpath("//div[@class='job-title']//a//h2").each do |lo|
    #     title.push(lo.content)
    #   end
    #   doc.xpath("//li[@class='salary']").each do |sa|
    #     salary.push(sa.content)
    #   end
    #   doc.xpath("//li[@class='location']").each do |sa|
    #     location.push(sa.content.gsub("\n", '').lstrip.rstrip)
    #   end
    #   i = 0
    #   doc.xpath("//div[@class='job  '] | //div[@class='job new ']").each do |el|
    #     details = Nokogiri::HTML(open("https://www.totaljobs.com/job/" + el.attributes['id'].value ))
    #     description = details.xpath("//div[@class='job-description']")[0]
    #     tt_json.puts '{"title": "' + title[i] + '", "salary": "' + salary[i] + '", "location": "' + location[i] + '", "description:"' + description.to_html.gsub("\n", '').gsub("\r", '').gsub("\"", '\"') + '"},'
    #     i = i+ 1
    #   end
    # end

    # 30.times do |z|
    #   doc = Nokogiri::HTML(open('https://www.totaljobs.com/jobs/engineering?page=' + z.to_s))

    #   file = "totaljobs.json"
    #   title = []
    #   location = []
    #   salary = []
      
    #   tt_json.puts '['
    #   doc.xpath("//div[@class='job-title']//a//h2").each do |lo|
    #     title.push(lo.content)
    #   end
    #   doc.xpath("//li[@class='salary']").each do |sa|
    #     salary.push(sa.content)
    #   end
    #   doc.xpath("//li[@class='location']").each do |sa|
    #     location.push(sa.content.gsub("\n", '').lstrip.rstrip)
    #   end
    #   i = 0
    #   doc.xpath("//div[@class='job  '] | //div[@class='job new ']").each do |el|
    #     details = Nokogiri::HTML(open("https://www.totaljobs.com/job/" + el.attributes['id'].value ))
    #     description = details.xpath("//div[@class='job-description']")[0]
    #     tt_json.puts '{"title": "' + title[i] + '", "salary": "' + salary[i] + '", "location": "' + location[i] + '", "description:"' + description.to_html.gsub("\n", '').gsub("\r", '').gsub("\"", '\"') + '},'
    #     i = i+ 1
    #   end
    # end
    # (1..7).each do |z|
    #   doc = Nokogiri::HTML(open('https://www.totaljobs.com/jobs/finance?page=' + z.to_s))

    #   file = "totaljobs.json"
    #   title = []
    #   location = []
    #   salary = []
      
    #   doc.xpath("//div[@class='job-title']//a//h2").each do |lo|
    #     title.push(lo.content)
    #   end
    #   doc.xpath("//li[@class='salary']").each do |sa|
    #     salary.push(sa.content)
    #   end
    #   doc.xpath("//li[@class='location']").each do |sa|
    #     location.push(sa.content.gsub("\n", '').lstrip.rstrip)
    #   end
    #   i = 0
    #   doc.xpath("//div[@class='job  '] | //div[@class='job new ']").each do |el|
    #     details = Nokogiri::HTML(open("https://www.totaljobs.com/job/" + el.attributes['id'].value ))
    #     description = details.xpath("//div[@class='job-description']")[0]
    #     tt_json.puts '{"title": "' + title[i] + '", "salary": "' + salary[i] + '", "location": "' + location[i] + '", "description":"' + description.to_html.gsub("\n", '').gsub("\r", '').gsub("\"", '\"') + '"},'
    #     i = i+ 1
    #   end
    # end
    # (1..5).each do |z|
    #   doc = Nokogiri::HTML(open('https://www.totaljobs.com/jobs/manufacturing?page=' + z.to_s))

    #   file = "totaljobs.json"
    #   title = []
    #   location = []
    #   salary = []
      
    #   doc.xpath("//div[@class='job-title']//a//h2").each do |lo|
    #     title.push(lo.content)
    #   end
    #   doc.xpath("//li[@class='salary']").each do |sa|
    #     salary.push(sa.content)
    #   end
    #   doc.xpath("//li[@class='location']").each do |sa|
    #     location.push(sa.content.gsub("\n", '').lstrip.rstrip)
    #   end
    #   i = 0
    #   doc.xpath("//div[@class='job  '] | //div[@class='job new ']").each do |el|
    #     details = Nokogiri::HTML(open("https://www.totaljobs.com/job/" + el.attributes['id'].value ))
    #     description = details.xpath("//div[@class='job-description']")[0]
    #     tt_json.puts '{"title": "' + title[i] + '", "salary": "' + salary[i] + '", "location": "' + location[i] + '", "description":"' + description.to_html.gsub("\n", '').gsub("\r", '').gsub("\"", '\"') + '"},'
    #     i = i+ 1
    #   end
    # end
    (6..10).each do |z|
      doc = Nokogiri::HTML(open('https://www.totaljobs.com/jobs/apprenticeships?page=' + z.to_s))

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