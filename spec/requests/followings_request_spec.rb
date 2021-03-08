require 'rails_helper'

RSpec.describe 'Followings', type: :request do
  let!(:user) { create(:user) }
  let!(:following_user) { create(:user) }
  let!(:following_user2) { create(:user) }

  describe 'GET /api/v1/users/:user_id/followings' do
    before { user.following_users << [following_user, following_user2] }
    it 'returns following users' do
      get "/api/v1/users/#{user.id}/followings"

      expect(response.parsed_body).to include({ 'id' => following_user.id, 'name' => following_user.name })
      expect(response.parsed_body).to include({ 'id' => following_user2.id, 'name' => following_user2.name })
    end
  end

  describe 'POST /api/v1/followings' do
    context 'when follows user' do
      it 'creates follow' do
        post '/api/v1/followings', params: { user_id: user.id, following_user_id: following_user.id }

        expect(response).to have_http_status(:created)
        expect(response.body).to match(/Follow Success/)
        expect(user.reload.following_users).to include following_user
      end
    end

    context 'when follows same user twice' do
      before { user.following_users << following_user }

      it 'returns unprocessable_entity with error' do
        post '/api/v1/followings', params: { user_id: user.id, following_user_id: following_user.id }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body).to include({ 'error' => ['Following relationship has already existed'] })
      end
    end
  end

  describe 'DELETE /api/v1/followsing/:id' do
    before { user.following_users << following_user }
    it 'unfollow user by id' do
      delete "/api/v1/followings/#{following_user.id}", params: { user_id: user.id }

      expect(response).to have_http_status(:ok)
      expect(response.body).to match(/Unfollow Success/)
      expect(user.reload.following_users).not_to include following_user
    end
  end
end
