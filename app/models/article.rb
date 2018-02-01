class Article < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings  do
    mapping do
      indexes :title, type: 'text', boost: 2
      indexes :content, type: 'text', boost: 1
    end
  end
end
