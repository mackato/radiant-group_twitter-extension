class CreateGroupTwitterAccounts < ActiveRecord::Migration
  def self.up
    create_table :group_twitter_accounts do |t|
      t.integer :user_id
      t.string :screen_name
      t.string :name
      t.string :profile_image_url
      t.string :access_token

      t.timestamps
    end
  end

  def self.down
    drop_table :group_twitter_accounts
  end
end
