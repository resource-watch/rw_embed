class EmbedArraySerializer < ActiveModel::Serializer
  attributes :id, :slug, :title, :source_type, :status, :published

  def source_type
    object.try(:source_txt)
  end

  def status
    object.try(:status_txt)
  end
end
