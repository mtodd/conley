require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Nodes, "index action" do
  before(:each) do
    dispatch_to(Nodes, :index)
  end
end