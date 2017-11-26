class User < ApplicationRecord
  validates :sex, inclusion: { in: %w(male female) }

  has_and_belongs_to_many :tags
end
