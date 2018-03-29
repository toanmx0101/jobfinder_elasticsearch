require 'json'

puts "Deleting all jobs..."
Job.delete_all
# 20000.times do
#   job = Job.new
#   job.title = Faker::Job.title
#   job.about_candidate = Faker::Job.key_skill
#   job.employment_type = Faker::Job.employment_type
#   job.education_level = Faker::Job.education_level
#   job.city = Faker::Address.city
# end
puts "Generate jobs from json"
User.create(email: 'zinza1@gmail.com', password: 'zinza123@', password_confirmation: 'zinza123@')
file = File.read('lib/assets/jobs.json')
data_hash = JSON.parse(file)
user = User.first
data_hash.each do |job|
  x = Job.create(title: job['text'], description: job['description'], about_candidate: job['search_text'], user_id: user.id, location: job['location'], state: 'published', view_count: Faker::Number.between(100, 1000))
end

puts "Deleting all companies"
puts "Generate companies from json"


