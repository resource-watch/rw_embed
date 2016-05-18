class EmbedArraySerializer < ActiveModel::Serializer
  attributes :id, :slug, :source_type, :status, :title

  def source_type
    object.try(:source_txt)
  end

  def status
    object.try(:status_txt)
  end
end
