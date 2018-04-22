require 'json'
require 'stringex'

puts "Deleting all  user "
User.delete_all
puts "Generate user"


User.create(email: 'user1@example.com', password: 'password',username: 'Avicii',  password_confirmation: 'password', work_position: 'English Language Teacher', description: 'I am a progressive thinker who utilizes creativity, leadership and effective teamwork to design and accomplish solutions that generate the client\'s value. Effective communicator with ability to produce marketing materials that brings value for both clients and end users.')


100.times do |i| 
  username  = Faker::Internet.user_name(6)
  User.create(email: Faker::Internet.safe_email, 
    username: username, 
    avatar_url: Faker::Avatar.image(username, "144x144"), 
    password: 'password',  
    password_confirmation: 'password', 
    work_position: Faker::Job.position, 
    description: Faker::Company.bs,
    user_type: 'normal')
end

puts "Generate recruitment manager" 
20.times do |i| 
  User.create(email: 'recruitment_manager_' + i.to_s + '@example.com', 
    username: Faker::Internet.user_name(6), 
    avatar_url: Faker::Avatar.image("144x144"), 
    password: 'password',  
    password_confirmation: 'password', 
    work_position: Faker::Job.position, 
    description: Faker::Company.bs,
    user_type: 'recruiter')
end

puts "Generate Elasticsearch recruitment manager"
User.create(email: 'elastic@example.com', password: 'password',username: 'elastic', avatar_url: Faker::Avatar.image("144x144"),  password_confirmation: 'password', user_type: 'recruiter')

puts "Generate Netfix recruitment manager"
User.create(email: 'netfix@example.com', password: 'password',username: 'netfix', avatar_url: Faker::Avatar.image("144x144"),  password_confirmation: 'password', user_type: 'recruiter')
############################################################

puts "Deleting all jobs..."
Job.delete_all
puts "Generate netfix jobs"
netfix_recruiter = User.where(email: 'netfix@example.com').first
file = File.read('lib/assets/jobs.json')
data_hash = JSON.parse(file)
data_hash.each do |job|
  Job.create( title: job['text'], 
                  description: job['description'], 
                  about_candidate: job['search_text'], 
                  user_id: netfix_recruiter.id, 
                  location: job['location'], 
                  state: 'published',
                  slug: job['slug'],
                  view_count: Faker::Number.between(100, 1000), 
                  job_type: Faker::Job.employment_type, 
                  pay_rate: Faker::Number.between(6, 10).to_s + "0000$ per year",
                  start_at: Faker::Date.between(1.week.ago, Date.today),
                  end_at: Faker::Date.between(3.month.from_now, Date.today)
                  )
end

puts "Generate elastic jobs"
file = File.read('lib/assets/elas_jobs.json')
data_hash = JSON.parse(file)
elastic_recruiter = User.where(email: 'elastic@example.com').first
des = "Elastic is on a mission to make real-time data exploration easy and available to anyone. As the company behind the popular open source projects Elasticsearch, Kibana, Logstash, and Beats, we're looking to hire team members invested in realizing this goal. As a distributed company with employees in 30 countries (and counting), spread across 18 time zones, speaking over 30 languages, we believe that diversity drives our vibe. Whether you're looking to launch a new career or grow an existing one, Elastic is the type of company where you can balance great work with great life. View list of Elastic jobs below."
data_hash.each do |job|
  x = Job.create( title: job['title'],
                  description: des,  
                  about_candidate: job['description'], 
                  user_id: elastic_recruiter.id,
                  location: job['location'], 
                  slug: job['title'].to_url,
                  state: 'published', 
                  view_count: Faker::Number.between(100, 1000), 
                  job_type: Faker::Job.employment_type, 
                  pay_rate: Faker::Number.between(6, 10).to_s + "0000& per year",
                  start_at: Faker::Date.between(2.week.ago, Date.today),
                  end_at: Faker::Date.between(3.month.from_now, Date.today)
                )
end

puts "Generate total jobs"
file = File.read('lib/assets/total_jobs.json')
data_hash = JSON.parse(file)
data_hash.each do |job|
  user_id = User.where(user_type: 'recruiter').map(&:id).sample
  Job.create( title: job['title'],  
              about_candidate: job['description'], 
              user_id: user_id,
              location: job['location'],
              slug: job['title'].to_url,
              state: 'published', 
              view_count: Faker::Number.between(100, 1000), 
              job_type: Faker::Job.employment_type,
              pay_rate: job['salary'],
              start_at: Faker::Date.between(2.week.ago, Date.today),
              end_at: Faker::Date.between(3.month.from_now, Date.today)
    )
end
  
puts "Deleting all companies"
Company.delete_all
puts "Generate companies from json"

file = File.read('lib/assets/companies.json')
data_hash = JSON.parse(file)
data_hash.each do |company|
  Company.create( company_name: company['company_name'],  
              description: company['description'], 
              city: company['city'], 
              website: company['website'], 
              size: company['size'],
              industry: company['industry'] , 
              specialities: company['specialities'],
              company_logo: Faker::Company.logo
    )
end


