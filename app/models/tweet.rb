class Tweet < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user, :body
  after_save :update_status
  
  PUBLISHED = 1
  
  def published?
    self.status == PUBLISHED
  end
  
  def update_status
    self.status = PUBLISHED
  end
end
