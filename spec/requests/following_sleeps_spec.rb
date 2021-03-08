require 'rails_helper'

RSpec.describe 'FollowingSleeps' do
  before do
    Timecop.freeze(Time.local(2021, 1, 1, 0))
  end

  describe '/api/v1/users/:user_id/following_sleeps' do
    let!(:user) { create(:user) }
    let!(:following_user) { create(:user) }
    let!(:short_sleep) { create(:sleep, user: following_user, start_at: 10.hours.ago, end_at: 5.hours.ago) }
    let!(:long_sleep) { create(:sleep, user: following_user, start_at: 10.hours.ago, end_at: 2.hours.ago) }
    let!(:old_sleep) { create(:sleep, user: following_user, start_at: 1.month.ago, end_at: 1.month.ago + 8.hour) }

    before { user.following_users << following_user }

    it 'returns a list of the sleep of following users' do
      get "/api/v1/users/#{user.id}/following_sleeps"

      expect(response.parsed_body).to eq(
        [
          {
            'id' => long_sleep.id,
            'start_at' => long_sleep.start_at.as_json,
            'end_at' => long_sleep.end_at.as_json,
            'duration' => 8.hours.to_i,
            'user_id' => following_user.id,
            'user_name' => following_user.name
          },
          {
            'id' => short_sleep.id, 
            'start_at' => short_sleep.start_at.as_json,
            'end_at' => short_sleep.end_at.as_json,
            'duration' => 5.hours.to_i,
            'user_id' => following_user.id,
            'user_name' => following_user.name
          }
        ]
      )
    end
  end
end
