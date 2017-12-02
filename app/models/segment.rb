class Segment < ApplicationRecord
  validates :data, segment: true
  validates :name, presence: true, uniqueness: true

  before_save :slugify_name

  def segmented
    User
  end

  private

  def slugify_name
    self.slug = name&.parameterize
  end
end
