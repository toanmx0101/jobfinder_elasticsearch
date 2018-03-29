json.extract! job, :id, :title, :content, :published_on, :created_at, :updated_at
json.url job_url(job, format: :json)
