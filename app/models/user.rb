class User < ApplicationRecord
  has_and_belongs_to_many :tags

  accepts_nested_attributes_for :tags, allow_destroy: true

  validates :email, uniqueness: true
  validates :sex, inclusion: { in: %w(male female) }
  validates :is_active, inclusion: { in: [true, false] }
  validates :first_name, :last_name, :email, :birth_date,
            :admission_date, :sex, :last_sign_in_at, presence: true


  class << self
    def has_column?(field)
      column_names.include?(field.to_s)
    end

    def has_association?(field)
      reflect_on_association(field).present?
    end

    %i[string date boolean datetime].each do |type|
      define_method("#{type}_field?") do |field|
        type_for_attribute(field.to_s).type == type
      end
    end
  end
end
