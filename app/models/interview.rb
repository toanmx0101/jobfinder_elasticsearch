class Interview < ApplicationRecord
  belongs_to :recruiter, class_name: "User"
  belongs_to :interviewer, class_name: "User"
  
  def accepted?
    
  end

  def out_date?

  end

end
