# frozen_string_literal: true
# == Schema Information
#
# Table name: sources
#
#  id         :uuid             not null, primary key
#  acronym    :string
#  url        :string
#  logo_url   :string
#  partner    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Source < ApplicationRecord
  has_one :embed, as: :embedable, dependent: :destroy, inverse_of: :embedable
  accepts_nested_attributes_for :embed, allow_destroy: true, update_only: true
end
