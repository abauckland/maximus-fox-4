FactoryGirl.define do 

  factory :home do 
  end 
  
  factory :about do 
#    title 'about title'
    text 'about text'
    image 'F3-1'
    order 1
  end  

  factory :faq do 
    question 'faq question'
    answer 'faq answer'
  end  

  factory :termcat do 
    text 'term category'
  end 

  factory :term do 
    termcat
    text 'term'
  end 

  factory :featurecontent do 
    feature
    order 1
    title 'feature content title'
    text 'feature content text'
    image 'F3-1'
  end

  factory :feature do 
    title 'feature title'
    text 'feature text'
    image 'F3-1'
    
    factory :feature_with_contents do
      ignore do
        featurecontent_count 3
      end      
      after(:create) do |feature, evaluator|
        create_list(:featurecontent, evaluator.featurecontent_count, feature: feature)
      end 
    end
    
  end

  factory :planfeature do 
    priceplan
    text 'plan feature'
  end

  factory :priceplan do 
    name 'plan name'
    plan 'plan'
    sign_up 1
    
    factory :priceplan_with_features do
      ignore do
        planfeature_count 3
      end      
      after(:create) do |priceplan, evaluator|
        create_list(:planfeature, evaluator.planfeature_count, priceplan: priceplan)
      end 
    end
    
  end






end