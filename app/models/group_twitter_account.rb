class GroupTwitterAccount < ActiveRecord::Base
  validates_presence_of :user_id, :screen_name, :access_token, :access_token_secret
  validates_uniqueness_of :user_id
  
  def get_access_token
    access_token = OAuth::AccessToken.new(
      TwitterClient.consumer,
      self.access_token,
      self.access_token_secret
    )
  end
end
