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

require 'rails_helper'

RSpec.describe Embed, type: :model do
  let!(:embeds) {
    embeds = []
    embeds << EmbedApp.create!(source_url: 'http://test.embed-url.org', embed_attributes: { title: 'Embed app',     source_type: 0, slug: 'first-test-embed' })
    embeds << EmbedApp.create!(source_url: 'http://test.embed-url.org', embed_attributes: { title: 'Embed app two', summary: 'Lorem ipsum...' })

    embeds << Photo.create!(source_url: 'http://test.embed-url.org', embed_attributes: { title: 'Embed photo',   source_type: 1, slug: 'second-test-embed' })
    embeds.each(&:reload)
  }

  let!(:embed_first)  { embeds[0].embed }
  let!(:embed_second) { embeds[1].embed }
  let!(:embed_third)  { embeds[2].embed }

  it 'Is valid' do
    expect(embed_first).to      be_valid
    expect(embed_first.slug).to eq('first-test-embed')
  end

  it 'Generate slug after create' do
    expect(embed_third.slug).to eq('second-test-embed')
  end

  it 'Do not allow to create embed without title' do
    embed_reject = EmbedApp.new(embed_attributes: { title: '', slug: 'test' })

    embed_reject.valid?
    expect {embed_reject.save!}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Embed title can't be blank")
  end

  it 'Do not allow to create embed with wrong slug' do
    embed_reject = EmbedApp.new(embed_attributes: { title: 'test', slug: 'test&' })

    embed_reject.valid?
    expect {embed_reject.save!}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Embed slug invalid. Slug must contain at least one letter and no special character")
  end

  it 'Do not allow to create embed with title douplications' do
    expect(embed_first).to be_valid
    embed_reject = Photo.new(embed_attributes: { title: 'Embed app', slug: 'test' })

    embed_reject.valid?
    expect {embed_reject.save!}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Embed title has already been taken")
  end
end
