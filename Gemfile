source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'devise'
gem 'rails', '~> 5.1.4'
gem 'haml'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'therubyracer', platforms: :ruby
gem 'hirb'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'vuejs-rails'
gem 'select2-rails'
gem 'jquery-rails'
gem 'pry'
gem 'faker'
gem 'view_source_map'
gem 'htmlbeautifier'
gem 'kaminari'
gem 'friendly_id', '~> 5.1.0' 
gem 'stringex'
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'rspec-rails', '~> 3.0'
end

group :development do
	gem 'sqlite3'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'mocha', group: 'test', require: 'mocha/api'
gem 'rails-controller-testing', group: 'test'
gem 'elasticsearch', git: 'git://github.com/elasticsearch/elasticsearch-ruby.git'
gem 'elasticsearch-model', git: 'git://github.com/elasticsearch/elasticsearch-rails.git'
gem 'elasticsearch-rails', git: 'git://github.com/elasticsearch/elasticsearch-rails.git'
group :production do
	gem 'pg'
	gem 'rails_12factor'
end