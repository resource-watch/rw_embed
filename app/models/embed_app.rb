# == Schema Information
#
# Table name: embed_apps
#
#  id          :uuid             not null, primary key
#  source_url  :string           not null
#  settings    :jsonb
#  source_code :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class EmbedApp < ApplicationRecord
  has_one :embed, as: :embedable, dependent: :destroy, inverse_of: :embedable
  accepts_nested_attributes_for :embed, allow_destroy: true, update_only: true
end
