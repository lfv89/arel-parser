class Segment < ApplicationRecord
  validates :data, segment: true
  validates :name, presence: true, uniqueness: true

  def segmented
    :user
  end
end
