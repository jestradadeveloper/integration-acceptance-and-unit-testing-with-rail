FactoryBot.define do
  factory :achievement do
    title { 'title' }
    description { 'description' }
    privacy { Achievement.privacies[:private_access] }
    featured { false }
    cover_image { 'some_file.png' }
    association :user, factory: :user
    factory :public_achievement do
      privacy { :public_access }
    end
    factory :private_achievement do
      privacy { :private_access }
    end
  end
end
