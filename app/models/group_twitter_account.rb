class GroupTwitterAccount < ActiveRecord::Base
  validates_presence_of :user_id, :screen_name, :access_token, :access_token_secret
  validates_uniqueness_of :user_id
end
