class Interview < ApplicationRecord
  belongs_to :recruiter, class_name: "User"
  belongs_to :interviewer, class_name: "User"
  
end
