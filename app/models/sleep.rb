class Sleep < ApplicationRecord
  belongs_to :user

  validates_numericality_of :end_at, greater_than: :start_at, if: :start_at, allow_nil: true

  before_save :count_duration

  private

  def count_duration
    new_duration = (end_at&.- start_at)&.round
    self.duration = new_duration if start_at && end_at && duration != new_duration
  end
end
