require 'rails_helper'

RSpec.describe "Sleeps", type: :request do
  let!(:user) { create(:user) }
  let(:start_at) { Time.local(2021, 1, 1, 0) }
  let(:end_at) { Time.local(2021, 1, 1, 8) }

  before do
    Timecop.freeze(start_at)
  end

  describe 'GET /api/v1/users/:user_id/sleeps' do
    let!(:sleep1) { create(:sleep, :recorded, user: user, created_at: Time.now.yesterday) }
    let!(:sleep2) { create(:sleep, :recorded, user: user, created_at: Time.now) }

    it 'returns all sleep orderd by created_at in desc' do
      get "/api/v1/users/#{user.id}/sleeps"

      expect(response).to have_http_status(:ok)
      expect(response.body).to match(/#{sleep2.to_json}.+#{sleep1.to_json}/)
    end
  end

  describe 'POST /api/v1/users/:user_id/sleeps' do
    let(:sleep) { Sleep.last }

    context 'when success' do
      it 'creates sleep with start_at' do
        post "/api/v1/users/#{user.id}/sleeps"

        expect(response).to have_http_status(:created)
        expect(sleep).to have_attributes(user_id: user.id, start_at: start_at)
      end
    end

    context 'when fail' do
      before { allow_any_instance_of(Sleep).to receive(:save).and_return(false) }

      it 'returns unprocessable_entity' do
        post "/api/v1/users/#{user.id}/sleeps"

        expect(response).to have_http_status(:unprocessable_entity)
        expect(sleep).to be_blank
      end
    end
  end

  describe 'PATCH /api/v1/users/:user_id/sleeps/:id' do
    before { Timecop.freeze(end_at) }

    context 'when the sleep exists' do
      let!(:sleep) { create(:sleep, user: user, start_at: start_at) }

      context 'when success' do
        it 'updates end_at of sleep' do
          patch "/api/v1/users/#{user.id}/sleeps/#{sleep.id}"

          expect(response).to have_http_status(:ok)
          expect(sleep.reload).to have_attributes(end_at: end_at)
        end
      end

      context 'when fail' do
        before { allow_any_instance_of(Sleep).to receive(:save).and_return(false) }
        it 'returns unprocessable_entity' do
          patch "/api/v1/users/#{user.id}/sleeps/#{sleep.id}"

          expect(response).to have_http_status(:unprocessable_entity)
          expect(sleep.reload).to have_attributes(end_at: nil)
        end
      end
    end

    context 'when sleep not found' do
      it 'returns not_found' do
        patch "/api/v1/users/#{user.id}/sleeps/9999"

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
