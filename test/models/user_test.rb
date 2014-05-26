require 'test_helper'

class UserTest < ActiveSupport::TestCase

#associations
   test "should be associated with company, projectusers, projects" do
     user = FactoryGirl.build_stubbed(:user)
     assert_respond_to(user, :projectusers)
     assert_respond_to(user, :projects)
     assert_respond_to(user, :company)
   end



#vaildations  
   test "should not save user without first name" do
      user = FactoryGirl.build(:user, first_name: "")
      assert_not user.valid?
   end

   test "should not save user without surname" do
      user = FactoryGirl.build(:user, surname: "")
      assert_not user.valid?
   end
   
   test "should not save user without password" do
      user = FactoryGirl.build(:user, password: "")
      assert_not user.valid?
   end   

   test "should not save user if password less than 8 characters" do
      user = FactoryGirl.build(:user, password: "my")
      assert_not user.valid?
      assert_equal ["Password must be minimum 8 characters long"], user.errors.messages[:password]
   end 

   test "should not save user without email" do
      user = FactoryGirl.build(:user, email: "")
      assert_not user.valid?
   end

   test "should not save user of email not correct format" do
      user = FactoryGirl.build(:user, email: "mystring@mystring")
      assert_not user.valid?
   end
   
   test "should not save user when email not unique" do
      user = FactoryGirl.build(:user, email: "mystring@mystring.com")
      user_copy = user.dup
      user.save
      user_copy.save
      
      assert_not user_copy.valid?
      assert_equal ["A user with this email address already exists"], user_copy.errors.messages[:email]
   end

#methods
   test "should combined first and surname" do
      user = FactoryGirl.build(:user)
      assert_equal "firstname surname 2", user.name
   end

   
   #validate format of email on save
   
   #generate token
   
   #send_password_reset
   
   #self.authenticate(email, password)
   
   #encrypt_password 

end   