require 'rails_helper'

RSpec.describe Achievement, type: :model do
  describe 'validations' do
    let(:user) { FactoryBot.create(:user) } # Create a user using your FactoryBot definition

    it 'validates uniqueness of title scoped to user' do
      FactoryBot.create(:achievement, user: user, title: 'Some Title') # Create an achievement for the user

      should validate_uniqueness_of(:title)
        .scoped_to(:user_id)
        .with_message("you can't have two achievements with the same title")
        .ignoring_case_sensitivity # If case-insensitive uniqueness validation is required
    end
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:user) }
    it { should belong_to(:user) }
    it 'converts markdown to html' do
      achievement = Achievement.new(description: 'Awesome **things** I *did* yesterday')
      expect(achievement.description_html).to include('<strong>things</strong>')
      expect(achievement.description_html).to include('<em>did</em>')
    end
    it 'has silly title' do
      achievement = Achievement.new(title: 'New Achievement', user: FactoryBot.create(:user, email: 'test@test.com'))
      expect(achievement.silly_title).to eq('New Achievement by test@test.com')
    end
    it 'only fetches achievements with title starts from provided letter' do
      achievement1 = FactoryBot.create(:public_achievement, title: 'Read a book', user: user)
      achievement2 = FactoryBot.create(:public_achievement, title: 'Passed an examp', user: user)
      expect(Achievement.by_letter('R')).to eq([achievement1])
    end
    it 'sorts achievements by user emails' do
      albert = FactoryBot.create(:user, email: 'albert@test.com')
      rob = FactoryBot.create(:user, email: 'rob@test.com')
      achievement1 = FactoryBot.create(:public_achievement, title: 'Read a book', user: rob)
      achievement2 = FactoryBot.create(:public_achievement, title: 'Rocked it', user: albert)

      expect(Achievement.by_letter("R")).to eq([achievement2,achievement1])
    end
  end
end
