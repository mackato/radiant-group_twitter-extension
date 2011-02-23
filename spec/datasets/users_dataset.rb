class UsersDataset < Dataset::Base
  # uses :users
  
  def load
    # %w(bob tom).each do |login|
    #   create_record :user, :"#{login}",
    #     :name => login, :login => login, :password => "#{login}#{login}", :admin => (login == "bob")
    # end
  end
end