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
#

class EmbedSerializer < ActiveModel::Serializer
  attributes :id, :slug, :source_type, :source_url, :thumbnail_url, :title, :summary, :content, :meta

  def source_type
    object.try(:source_txt)
  end

  def source_url
    object.embedable.try(:source_url)
  end

  def meta
    data = {}
    data['status']     = object.try(:status_txt)
    data['published']  = object.try(:published)
    data['updated_at'] = object.try(:updated_at)
    data['created_at'] = object.try(:created_at)
    data
  end
end
