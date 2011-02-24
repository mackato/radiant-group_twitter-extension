class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.integer :user_id
      t.integer :group_twitter_account_id
      t.string :body
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :tweets
  end
end
