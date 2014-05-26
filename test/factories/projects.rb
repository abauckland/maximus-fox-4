FactoryGirl.define do 
 
 
  sequence(:company_name) {|n|"company name #{n}" }

  
  factory :company do 
    name { generate(:company_name) }
    tel 1612744613
    www 'website.co.uk'
    reg_address 'company address'
    reg_number 123456789
    reg_name 'reg name'
    reg_location 'reg location'
    read_term 1
    category 1
    no_licence 2
    check_field ''

    factory :company_with_user do
      ignore do
        user_count 2
      end      
      after(:create) do |company, evaluator|
        create_list(:user, evaluator.user_count, company: company)
      end 
    end

  end

  sequence(:user_surname) { |n| "surname #{n}" }
  sequence(:user_email) { |n| "#{n}@address.co.uk" }
  
  factory :user do
        
    company 
    first_name 'firstname'
    surname { generate(:user_surname) }
    email { generate(:user_email) }
    password '12345678'
    role 1
    failed_attempts 0
    locked_at 0
    number_times_logged_in 0
    active 1
    last_sign_in Time.now
    ip '127.0.0.1'
  end

  sequence(:project_code) { |n| "P1#{n}" }
  sequence(:project_title) { |n| "project title #{n}" } 

  factory :project do

    code { generate(:project_code) }
    title { generate(:project_title) }
    parent_id 1
    project_status 1
    ref_system 1
  end

  factory :projectuser do
    user
    project
    role 'owner'
  end

  factory :cawssection do 
    ref 'A'
    text 'Cawssection'
  end

  factory :cawssubsection do 
    cawssection
    ref 10
    text 'Cawssubsection'
    guidepdf_id 1 
  end

  factory :unisection do 
    ref '10-10'
    text 'Unisection'
  end

  factory :unisubsection do 
    cawssection
    ref '-10'
    text 'Unisubsection'
    guidepdf_id 1 
  end

  factory :subsection do 
    cawssubsection
    unisubsection
  end

  factory :clausetype do 
    text 'Clausetype'
  end

  factory :clauseref do 
    subsection
    clausetype
    clause 1
    subclause 1
  end

  factory :clausetitle do 
    text 'Clausetitle'
  end

  factory :guidenote do 
    text 'guidenote text'
  end

  factory :clause do
    clauseref
    clausetitle
    project
    guidenote 
  end

  factory :linetype do 
    ref 'l1'
    description 'linetype description'
    example 'linetype example'
    txt1 1
    txt2 1
    txt3 1
    txt4 1
    txt5 1
    txt6 1
    identity 1
    perform 1
  end

  factory :lineclausetype do
    clausetype
    linetype
  end 
  
  factory :txt1 do 
    text 'a'
  end

  factory :txt2 do 
    text 'ii'
  end

  factory :txt3 do 
    text 'text type 3'
  end

  factory :txt4 do 
    text 'text type 4'
  end

  factory :txt5 do 
    text 'text type 5'
  end

  factory :txt6 do 
    text 'text type 6'
  end

  factory :identity do 

  end

  factory :perform do 

  end

  factory :specline do
    project
    clause
    linetype    
    txt1
    txt2
    txt3
    txt4
    txt5
    txt6
    identity
    perform
    
    clause_line 1
  end
      
end