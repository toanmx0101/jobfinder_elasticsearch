class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :jobs, dependent: :destroy

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings  do
    mapping do
      indexes :title, type: 'text', boost: 2
      indexes :content, type: 'text', boost: 1
    end
  end
end
