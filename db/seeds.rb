# require 'json'
# require 'stringex'

# puts "Deleting all  user "
# User.delete_all
# puts "Generate user"
# username  = Faker::Internet.user_name(6).gsub('.', '_')

# User.create(email: 'job_finder@example.com',avatar_url: "/images/logo.png",  password: 'password',username: 'JobFinder',  password_confirmation: 'password', work_position: 'Job Finder Admin', description: 'I am boss')

# User.create(email: 'user1@example.com',avatar_url: Faker::Avatar.image(username, "144x144"),  password: 'password',username: 'Avicii',  password_confirmation: 'password', work_position: 'English Language Teacher', description: 'I am a progressive thinker who utilizes creativity, leadership and effective teamwork to design and accomplish solutions that generate the client\'s value. Effective communicator with ability to produce marketing materials that brings value for both clients and end users.')

# job_background = ["000000", "99999", "188035", "236709", "239898", "247763", "256219", "256381", "257856",
#   "270695", "273244", "273254", "301930", "325229", "326410", "356040", "356830", "433154", "585419", "811107", "839934",
#   "416408", "668296", "1011668", "371938", "207731", "942424", "265125", "301871", "441963", "724921", "1011666", "1011667",
#   "358667", "389819", "417352", "256297", "236093", "373543", "1011665", "625279", "461146", "961250"]



# 20.times do |i|
#   username  = Faker::Internet.user_name(6).gsub('.', '_')
#   User.create(email: Faker::Internet.safe_email,
#     username: username,
#     avatar_url: Faker::Avatar.image(username, "144x144"),
#     password: 'password',
#     password_confirmation: 'password',
#     work_position: Faker::Job.position,
#     description: Faker::Company.bs,
#     user_type: 'normal',
#     view_history: [])
# end


# puts "Generate recruitment manager"
# 20.times do |i|
#   User.create(email: 'recruitment_manager_' + i.to_s + '@example.com',
#     username: Faker::Internet.user_name(6).gsub('.', '_'),
#     avatar_url: Faker::Avatar.image("144x144"),
#     password: 'password',
#     password_confirmation: 'password',
#     work_position: Faker::Job.position,
#     description: Faker::Company.bs,
#     user_type: 'recruiter')
# end

# puts "Generate Elasticsearch recruitment manager"
# User.create(email: 'elastic@example.com', password: 'password',username: 'elastic', avatar_url: Faker::Avatar.image("144x144"),  password_confirmation: 'password', user_type: 'recruiter')

# puts "Generate Netfix recruitment manager"
# User.create(email: 'netfix@example.com', password: 'password',username: 'netfix', avatar_url: Faker::Avatar.image("144x144"),  password_confirmation: 'password', user_type: 'recruiter')
# ############################################################

# puts "Deleting all jobs..."
# Job.delete_all
# puts "Generate netfix jobs"
# netfix_recruiter = User.where(email: 'netfix@example.com').first
# file = File.read('lib/assets/jobs.json')
# data_hash = JSON.parse(file)
# data_hash.each do |job|
#   Job.create( title: job['text'],
#                   description: job['description'],
#                   about_candidate: job['search_text'],
#                   user_id: netfix_recruiter.id,
#                   location: job['location'],
#                   state: 'published',
#                   slug: job['slug'],
#                   view_count: Faker::Number.between(100, 1000),
#                   job_type: Faker::Job.employment_type,
#                   pay_rate: Faker::Number.between(6, 10).to_s + "0000$ per year",
#                   start_at: Faker::Date.between(1.week.ago, Date.today),
#                   end_at: Faker::Date.between(3.month.from_now, Date.today),
#                   background_url: "/images/background-job/pexels-photo-" + job_background.sample + ".jpeg"
#                   )
# end

# puts "Generate elastic jobs"
# file = File.read('lib/assets/elas_jobs.json')
# data_hash = JSON.parse(file)
# elastic_recruiter = User.where(email: 'elastic@example.com').first
# des = "Elastic is on a mission to make real-time data exploration easy and available to anyone. As the company behind the popular open source projects Elasticsearch, Kibana, Logstash, and Beats, we're looking to hire team members invested in realizing this goal. As a distributed company with employees in 30 countries (and counting), spread across 18 time zones, speaking over 30 languages, we believe that diversity drives our vibe. Whether you're looking to launch a new career or grow an existing one, Elastic is the type of company where you can balance great work with great life. View list of Elastic jobs below."
# data_hash.each do |job|
#   x = Job.create( title: job['title'],
#                   description: des,
#                   about_candidate: job['description'],
#                   user_id: elastic_recruiter.id,
#                   location: job['location'],
#                   slug: job['title'].to_url,
#                   state: 'published',
#                   view_count: Faker::Number.between(100, 1000),
#                   job_type: Faker::Job.employment_type,
#                   pay_rate: Faker::Number.between(6, 10).to_s + "0000& per year",
#                   start_at: Faker::Date.between(2.week.ago, Date.today),
#                   end_at: Faker::Date.between(3.month.from_now, Date.today),
#                   background_url: "/images/background-job/pexels-photo-" + job_background.sample + ".jpeg"
#                 )
# end

# puts "Generate total jobs"
# file = File.read('lib/assets/total_jobs.json')
# data_hash = JSON.parse(file)
# data_hash.each do |job|
#   user_id = User.where(user_type: 'recruiter').map(&:id).sample
#   Job.create( title: job['title'],
#               about_candidate: job['description'],
#               user_id: user_id,
#               location: job['location'],
#               slug: job['title'].to_url,
#               state: 'published',
#               view_count: Faker::Number.between(100, 1000),
#               job_type: Faker::Job.employment_type,
#               pay_rate: job['salary'],
#               start_at: Faker::Date.between(2.week.ago, Date.today),
#               end_at: Faker::Date.between(3.month.from_now, Date.today),
#               background_url: "/images/background-job/pexels-photo-" + job_background.sample + ".jpeg"
#     )
# end

# puts "Deleting all companies"
# Company.delete_all
# puts "Generate companies from json"

# file = File.read('lib/assets/companies.json')
# data_hash = JSON.parse(file)
# data_hash.each do |company|
#   Company.create( company_name: company['company_name'],
#               description: company['description'],
#               city: company['city'],
#               website: company['website'],
#               size: company['size'],
#               industry: company['industry'] ,
#               specialities: company['specialities'],
#               company_logo: Faker::Company.logo
#     )
# end

# puts "Delete applies"
# Apply.delete_all
# puts "Generate interview"
# 500.times do |i|
#   applyer_id = User.where(user_type: 'normal').map(&:id).sample
#   Apply.create(applyer_id: applyer_id, job_id: Job.all.sample.id)
# end

puts "Delete inteviews"
Interview.delete_all
puts "Generate interview"

500.times do |i|
  recruiter_id = User.where(user_type: 'recruiter').map(&:id).sample
  interviewer_id = User.where(user_type: 'normal').map(&:id).sample
  job_id = Job.where(user_id: recruiter_id).map(&:id).sample
  Interview.create(
    title: Faker::Job.title + ' - ' +Faker::Job.position + 'Interview',
    recruiter_id: recruiter_id,
    interviewer_id: interviewer_id,
    job_id: job_id,
    start_at: Faker::Time.between(3.week.from_now, Date.today, :day),
    duration: '1 hour',
    description: Faker::Lorem.sentence,
    location: Faker::Address.street_address
    )
end

# puts "Generate real profile"
# file = File.read('lib/assets/real_profile_user.json')
# data_hash = JSON.parse(file)
# data_hash.each do |u|
#   username  = Faker::Internet.user_name(6).gsub('.', '_')
#   User.create(email: Faker::Internet.safe_email,
#     username: username,
#     avatar_url: Faker::Avatar.image(username, "144x144"),
#     password: 'password',
#     password_confirmation: 'password',
#     work_position: u['work_position'],
#     description: u['description'],
#     experience: u['experience'],
#     education: u['education'],
#     user_type: 'normal',
#     view_history: [],
#     tags: Job.generate_tags(u['work_position']))
# end
# puts "sample history"

# User.all.each do |u|
#   if u.work_position
#     u.view_history  = Job.simple_match_jobs_query(u.work_position)
#     u.save
#   end
# end

# puts "Delete all message and conversation"
# Conversation.delete_all
# Message.delete_all


