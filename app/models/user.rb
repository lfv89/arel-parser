class User < ApplicationRecord
  has_and_belongs_to_many :tags

  accepts_nested_attributes_for :tags, allow_destroy: true

  validates :sex, inclusion: { in: %w(male female) }
  validates :is_active, inclusion: { in: [true, false] }
  validates :first_name, :last_name, :email, :birth_date,
            :admission_date, :sex, :last_sign_in_at, presence: true

  def self.segment(name)
    data = Segment.find_by!(name: name).data
    where(SegmentParser.new(data).parse)
  end
end
