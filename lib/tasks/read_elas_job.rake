require 'json'
require 'faker'
desc 'Read jobs file'


task read_elas_jobs_file: :environment do
  file = File.read('lib/assets/elas_jobs.json')
  data_hash = JSON.parse(file)
  des = "Elastic is on a mission to make real-time data exploration easy and available to anyone. As the company behind the popular open source projects Elasticsearch, Kibana, Logstash, and Beats, we're looking to hire team members invested in realizing this goal. As a distributed company with employees in 30 countries (and counting), spread across 18 time zones, speaking over 30 languages, we believe that diversity drives our vibe. Whether you're looking to launch a new career or grow an existing one, Elastic is the type of company where you can balance great work with great life. View list of Elastic jobs below."
  data_hash.each do |job|
    user = User.first
    x = Job.create(title: job['title'],description: des,  about_candidate: job['description'], user_id: user.id,location: job['location'], state: 'published', view_count: Faker::Number.between(100, 1000), type: 'Fulltime', pay_rate: Faker::Number.between(6, 10).to_s + "0000& per year")
  end
end
