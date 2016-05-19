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

class Embed < ApplicationRecord
  SOURCE = %w(application image).freeze
  STATUS = %w(pending saved failed deleted).freeze

  belongs_to :embedable, polymorphic: true

  before_update :assign_slug

  before_validation(on: [:create, :update]) do
    check_slug
  end

  validates :title, presence: true
  validates :slug,  presence: true, format: { with: /\A[^\s!#$%^&*()（）=+;:'"\[\]\{\}|\\\/<>?,]+\z/,
                                              allow_blank: true,
                                              message: 'invalid. Slug must contain at least one letter and no special character' }
  validates_uniqueness_of :title, :slug

  scope :recent,             -> { order('updated_at DESC') }
  scope :filter_pending,     -> { where(status: 0)         }
  scope :filter_saved,       -> { where(status: 1)         }
  scope :filter_failed,      -> { where(status: 2)         }
  scope :filter_inactives,   -> { where(status: 3)         }
  scope :filter_published,   -> { where(published: true)   }
  scope :filter_unpublished, -> { where(published: false)  }

  scope :filter_actives,   -> { filter_saved.filter_published }

  scope :filter_apps,   -> { where(embedable_type: 'EmbedApp').includes(:embedable) }
  scope :filter_images, -> { where(embedable_type: 'Photo').includes(:embedable)    }

  def source_txt
    SOURCE[source_type - 0]
  end

  def status_txt
    STATUS[status - 0]
  end

  def deleted?
    status_txt == 'deleted'
  end

  class << self
    def find_by_id_or_slug(param)
      embed_id = where(slug: param).or(where(id: param)).pluck(:id).min
      find(embed_id) rescue nil
    end

    def fetch_all(options)
      status     = options['status']    if options['status'].present?
      embed_type = options['type']      if options['type'].present?
      published  = options['published'] if options['published'].present?

      embeds = recent

      embeds = case status
               when 'pending'  then embeds.filter_pending
               when 'active'   then embeds.filter_actives
               when 'failed'   then embeds.filter_failed
               when 'disabled' then embeds.filter_inactives
               when 'all'      then embeds
               else
                 published.present? ? embeds : embeds.filter_actives
               end

      embeds = embeds.filter_published   if published.present? && published.include?('true')
      embeds = embeds.filter_unpublished if published.present? && published.include?('false')

      embeds = embeds.filter_images      if embed_type.present? && embed_type.include?('image')
      embeds = embeds.filter_apps        if embed_type.present? && embed_type.include?('app')
      embeds
    end

    def build_embed(options)
      embed_type = options['embed_attributes']['source_type'] if options['embed_attributes']['source_type'].present?
      case embed_type
      when 1
        Photo.new(options)
      else
        EmbedApp.new(options)
      end
    end
  end

  private

    def check_slug
      self.slug = self.title.downcase.parameterize if self.title.present? && self.slug.blank?
    end

    def assign_slug
      self.slug = self.slug.downcase.parameterize
    end
end
