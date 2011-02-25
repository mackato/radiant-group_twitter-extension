class Tweet < ActiveRecord::Base
  belongs_to :user
  belongs_to :group_twitter_account
  validates_presence_of :user, :body
 
  FAILD = 0 
  PUBLISHED = 1
  
  def published?
    self.status == PUBLISHED
  end
  
end
