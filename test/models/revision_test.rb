require 'test_helper'

class RevisionTest < ActiveSupport::TestCase
#associations
   test "should be associated with project, alterations" do
     revision = Revision.new
     assert_respond_to(revision, :project)
     assert_respond_to(revision, :alterations)
     assert_respond_to(revision, :prints)
   end
end
