require 'json'

puts "Deleting all jobs..."
# 20000.times do
#   job = Job.new
#   job.title = Faker::Job.title
#   job.about_candidate = Faker::Job.key_skill
#   job.employment_type = Faker::Job.employment_type
#   job.education_level = Faker::Job.education_level
#   job.city = Faker::Address.city
# end
Job.delete_all
puts "Generate jobs from json"
User.create(email: 'zinza1@gmail.com', password: 'zinza123@', password_confirmation: 'zinza123@')
file = File.read('lib/assets/jobs.json')
data_hash = JSON.parse(file)
user = User.first
data_hash.each do |job|
  x = Job.create(title: job['text'], description: job['description'], about_candidate: job['search_text'], user_id: user.id, location: job['location'], state: 'published', view_count: Faker::Number.between(100, 1000), job_type: 'Fulltime', pay_rate: Faker::Number.between(6, 10).to_s + "0000& per year")
end

file = File.read('lib/assets/elas_jobs.json')
data_hash = JSON.parse(file)
des = "Elastic is on a mission to make real-time data exploration easy and available to anyone. As the company behind the popular open source projects Elasticsearch, Kibana, Logstash, and Beats, we're looking to hire team members invested in realizing this goal. As a distributed company with employees in 30 countries (and counting), spread across 18 time zones, speaking over 30 languages, we believe that diversity drives our vibe. Whether you're looking to launch a new career or grow an existing one, Elastic is the type of company where you can balance great work with great life. View list of Elastic jobs below."
data_hash.each do |job|
  user = User.first
  x = Job.create(title: job['title'],description: des,  about_candidate: job['description'], user_id: user.id,location: job['location'], state: 'published', view_count: Faker::Number.between(100, 1000), job_type: 'Fulltime', pay_rate: Faker::Number.between(6, 10).to_s + "0000& per year")
end
  
puts "Deleting all companies"
puts "Generate companies from json"


