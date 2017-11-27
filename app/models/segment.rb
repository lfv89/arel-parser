class Segment < ApplicationRecord
  validates :data, segment: true
  validates :name, presence: true

  def segmented
    :user
  end
end
