require 'json'
require 'faker'
desc 'Read jobs file'


task read_jobs_file: :environment do
  file = File.read('lib/assets/jobs.json')
  data_hash = JSON.parse(file)
  data_hash.each do |job|
    user = User.first
    x = Job.create(title: job['text'], description: job['description'], about_candidate: job['search_text'], user_id: user.id,location: job['location'], state: 'published', view_count: Faker::Number.between(100, 1000), type: 'Fulltime', pay_rate: Faker::Number.between(6, 10) + "0000& per year")
  end
end
