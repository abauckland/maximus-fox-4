require 'test_helper'

class UserTest < ActiveSupport::TestCase

#associations
   test "should be associated with company, projectusers, projects" do
     user = User.new
     assert_respond_to(user, :projectusers)
     assert_respond_to(user, :projects)
     assert_respond_to(user, :company)
   end



#vaildations
   test "should not save user without first name" do
      user = User.create(surname: 'testname')
      assert_not user.valid?
      assert_equal ["First name cannot be blank", "please enter a valid name"], user.errors.messages[:first_name]
   end

   test "should not save if first name is not alphanumeric" do
      user = User.create(first_name: 'test2name', surname: 'testname')
      assert_not user.valid?
      assert_equal ["please enter a valid name"], user.errors.messages[:first_name]
   end

   test "should not save user without surname" do
      user = User.create(first_name: 'testname')
      assert_not user.valid?
      assert_equal ["Surname cannot be blank", "please enter a valid name"], user.errors.messages[:surname]
   end

   test "should not save if surname is not alphanumeric" do
      user = User.create(first_name: 'testname', surname: 'test2name')
      assert_not user.valid?
      assert_equal ["please enter a valid name"], user.errors.messages[:surname]
   end


#methods
   test "should combined first and surname" do
      user = users(:admin)
      assert_equal "Admin_one Sample_surname", user.name
   end

   #validate format of email on save

   #generate token

   #send_password_reset

   #self.authenticate(email, password)

   #encrypt_password

end