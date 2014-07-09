# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :print do
    project_id 1
    revision_id 1
    user_id 1
    document "MyString"
  end
end
