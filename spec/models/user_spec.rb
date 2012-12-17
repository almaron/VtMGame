describe User do
  it "should be valid" do
    User.new(:name => "User", :email => "almaron@gmail.com", :password => "qwsazx", :password_confirmation => "qwsazx").should be_valid
  end

  it "should not be valid" do
    User.new(:name => "User", :password => "qwsazx", :password_confirmation => "qwsazx").should_not be_valid
    User.new(:name => "User", :email => "almaron@gmail.com", :password => "qwsazx", :password_confirmation => "qwsazxqw").should_not be_valid
  end
end
