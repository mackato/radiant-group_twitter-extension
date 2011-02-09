class Tweet < ActiveRecord::Base
  validates_presence_of :body
  validates_length_of :body, :maximum => 140

  def get_tweets(limit)
    return Tweet.find(:all,:limit => limit )
  end

end
