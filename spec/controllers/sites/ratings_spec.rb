require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Sites::Ratings, "index action" do
  before(:each) do
    dispatch_to(Sites::Ratings, :index)
  end
end