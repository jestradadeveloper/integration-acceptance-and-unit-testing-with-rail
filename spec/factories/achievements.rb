FactoryBot.define do
  factory :achievement do
    title { 'title' }
    description { 'description' }
    privacy { 1 }
    featured { false }
    cover_image { 'some_file.png' }
  end
end
