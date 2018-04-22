class Message < ApplicationRecord
  after_create_commit { notify }

  private
  def notify
    
  end
end
