# frozen_string_literal: true
# == Schema Information
#
# Table name: embeds
#
#  id             :uuid             not null, primary key
#  embedable_id   :uuid
#  embedable_type :string
#  title          :string           not null
#  slug           :string
#  summary        :text
#  content        :text
#  source_type    :integer          default(0)
#  status         :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  published      :boolean          default(FALSE)
#

class EmbedSerializer < ApplicationSerializer
  attributes :id, :slug, :source_type, :source_url, :thumbnail_url, :title, :summary, :content, :source

  def source_type
    object.try(:source_txt)
  end

  def source_url
    object.embedable.try(:source_url)
  end

  def source
    data = {}
    data['acronym']  = object.embedable.try(:acronym)
    data['url']      = object.embedable.try(:url)
    data['logo_url'] = object.embedable.try(:logo_url)
    data['partner']  = object.embedable.try(:partner)
    data
  end
end
