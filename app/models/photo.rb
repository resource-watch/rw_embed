# == Schema Information
#
# Table name: photos
#
#  id         :uuid             not null, primary key
#  source_url :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Photo < ApplicationRecord
  has_one :embed, as: :embedable, dependent: :destroy, inverse_of: :embedable
  accepts_nested_attributes_for :embed, allow_destroy: true, update_only: true
end
