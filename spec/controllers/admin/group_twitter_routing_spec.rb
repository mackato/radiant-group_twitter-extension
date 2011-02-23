require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::CommentsController do
  dataset :users_and_pages
  before(:each) do
    login_as :admin
  end

  describe "routing" do
    it "should route to index by default" do
      params_from(:get, admin_group_twitter_path).should == {
        :controller => "admin/group_twitter", :action => "index"
      }
    end
    
    it "could route to action" do
      params_from(:get, admin_group_twitter_path(:action => 'auth_by_twitter')).should == {
        :controller => "admin/group_twitter", :action => "auth_by_twitter"
      }
    end
  end
end