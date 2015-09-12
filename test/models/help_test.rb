require 'test_helper'

class HelpTest < ActiveSupport::TestCase

  test "Help saves with all parameters" do
    help = Help.create( item: 'test_name', text: '<p>Test Text</p>' )
    assert help.valid?, 'The help record did not save'
  end

  test "Help doesn't save without item parameter" do
    help = Help.create(text: '<p>Test Text</p>')
    assert_not help.valid?, 'The help record should not be valid when missing item'
    assert_equal ["can't be blank"], help.errors.messages[:item]
  end

  test "Help saves without text parameter" do
    help = Help.create(item: 'test_name')
    assert help.valid?, 'The help record should save if text is missing'
  end


  test "Help with duplicate item name does not save" do
    help = Help.create( item: 'project_code', text: '<p>Test Text</p>' )

    assert_not help.valid?, 'The help record should not be valid an existing record with the same item name exists'
    assert_equal ["A help item for the same reference already exists"], help.errors.messages[:item]
  end

end
