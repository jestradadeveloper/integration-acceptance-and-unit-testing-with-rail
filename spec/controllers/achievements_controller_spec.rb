require 'rails_helper'

describe AchievementsController do
  shared_examples 'public access to achievement' do
    describe 'GET index' do
      it 'renders :index template' do
        get :index
        expect(response).to render_template(:index)
      end
      it 'assigns only public achievements to template' do
        public_achievement = FactoryBot.create(:public_achievement)
        private_achievement = FactoryBot.create(:private_achievement)
        get :index
        expect(assigns(:achievements)).to match_array([public_achievement])
      end
    end
    describe 'GET show' do
      let(:achievement) { FactoryBot.create(:public_achievement) }
      it 'renders :show template' do
        get :show, params: { id: achievement }
        expect(response).to render_template(:show)
      end
      it 'assigns requested achievement to @achievement' do
        get :show, params: { id: achievement }
        expect(assigns(:achievement)).to eq(achievement)
      end
    end
  end
  describe 'guest user' do
    it_behaves_like 'public access to achievement'
    describe 'GET new' do
      it 'redirect to login page' do
        get :new
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe 'POST create' do
      it 'redirect to login page' do
        post :create, params: { achievement: FactoryBot.attributes_for(:public_achievement) }
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe 'GET edit' do
      it 'redirect to login page' do
        get :edit, params: { id: FactoryBot.create(:public_achievement) }
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe 'PUT update' do
      context 'valid data' do
        it 'redirect to login page' do
          put :update,
              params: { id: FactoryBot.create(:public_achievement),
                        achievement: FactoryBot.attributes_for(:public_achievement, title: 'New title') }
          expect(response).to redirect_to(new_user_session_url)
        end
      end
    end

    describe 'DELETE destroy' do
      it 'redirect to login page' do
        delete :destroy, params: { id: FactoryBot.create(:public_achievement) }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'authenticated user' do
    let(:user) { FactoryBot.create(:user) }
    before do
      sign_in(user)
    end

    it_behaves_like 'public access to achievement'

    describe 'GET new' do
      it 'renders :new template' do
        get :new
        expect(response).to render_template(:new)
      end
      it 'assigns new Achievement to @achievement' do
        get :new
        expect(assigns(:achievement)).to be_a_new(Achievement)
      end
    end

    describe 'POST create' do
      context 'valid data' do
        let(:achievement_attributes) { FactoryBot.attributes_for(:public_achievement) }

        it 'redirects to achievements#show' do
          post :create, params: { achievement: achievement_attributes }
          expect(response).to redirect_to(achievement_path(Achievement.last))
        end

        it 'creates a new achievement in the database' do
          expect do
            post :create, params: { achievement: achievement_attributes }
          end.to change(Achievement, :count).by(1)
        end
      end
      context 'invalid data' do
        let(:invalid_data) { FactoryBot.attributes_for(:public_achievement, title: '') }
        it 'renders :new template' do
          post :create, params: { achievement: invalid_data }
          expect(response).to render_template(:new)
        end
        it "doesn't create a new achievement in the database" do
          expect do
            post :create, params: { achievement: invalid_data }
          end.not_to change(Achievement, :count)
        end
      end
    end

    context 'user is not the owner of the achievement' do
      let(:achievement) { FactoryBot.create(:public_achievement) }
      describe 'GET edit' do
        it 'redirect to achievement page' do
          get :edit, params: { id: achievement }
          expect(response).to redirect_to(achievements_path)
        end
      end

      describe 'PUT update' do
        context 'valid data' do
          it 'redirect to achievement page' do
            put :update,
                params: { id: FactoryBot.create(:public_achievement),
                          achievement: FactoryBot.attributes_for(:public_achievement, title: 'New title') }
            expect(response).to redirect_to(achievements_path)
          end
        end
      end

      describe 'DELETE destroy' do
        it 'redirect to achievement page' do
          delete :destroy, params: { id: FactoryBot.create(:public_achievement) }
          expect(response).to redirect_to(achievements_path)
        end
      end
    end

    context 'user is the owner of the achievement' do
      let(:achievement) { FactoryBot.create(:public_achievement, user: user) }

      describe 'GET edit' do
        it 'renders :edit template' do
          get :edit, params: { id: achievement }
          expect(response).to render_template(:edit)
        end
        it 'assigns the requested achievement to template' do
          get :edit, params: { id: achievement }
          expect(assigns(:achievement)).to eq(achievement)
        end
      end

      describe 'PUT update' do
        context 'valid data' do
          let(:valid_data) { FactoryBot.attributes_for(:public_achievement, title: 'New title') }
          it 'redirects to achievements#show' do
            put :update, params: { id: achievement, achievement: valid_data }
            expect(response).to redirect_to(achievement_path)
          end
          it 'updates achievements in the database' do
            put :update, params: { id: achievement, achievement: valid_data }
            achievement.reload
            expect(achievement.title).to eq('New title')
          end
        end
        context 'invalid data' do
          let(:invalid_data) { FactoryBot.attributes_for(:public_achievement, title: '', description: 'new') }
          it 'renders :edit template' do
            put :update, params: { id: achievement, achievement: invalid_data }
            expect(response).to render_template(:edit)
          end
          it "doesn't update achievement in database" do
            put :update, params: { id: achievement, achievement: invalid_data }
            achievement.reload
            expect(achievement.description).not_to eq('new')
          end
        end
      end
      describe 'DELETE destroy' do
        it 'redirects to achievements#index' do
          delete :destroy, params: { id: achievement }
          expect(response).to redirect_to(achievements_path)
        end
        it 'deletes achievement from database' do
          delete :destroy, params: { id: achievement }
          expect(Achievement.exists?(achievement.id)).to be_falsy
        end
      end
    end
  end
end
