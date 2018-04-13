require 'json'
require 'faker'
desc 'Read jobs file'


task read_elas_jobs_file: :environment do
  file = File.read('lib/assets/elas_jobs.json')
  data_hash = JSON.parse(file)
  data_hash.each do |job|
    user = User.first
    x = Job.create(title: job['title'],description: "xxx",  about_candidate: job['description'], user_id: user.id,location: job['location'], state: 'published', view_count: Faker::Number.between(100, 1000))
  end
end
