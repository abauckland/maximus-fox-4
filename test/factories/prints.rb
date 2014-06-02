# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :print do
    project_id 1
    revision_id 1
    user_id 1
    attachment_file_name "MyString"
    attachment_content_type "MyString"
    attachment_file_size "MyString"
    attachment_updated_at "MyString"
  end
end
