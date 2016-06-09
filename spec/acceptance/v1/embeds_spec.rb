require 'acceptance_helper'

module V1
  describe 'Embeds', type: :request do
    context 'Create, update and delete embeds' do
      let(:update_params) {{"embed": {
                            "source_url": "http://test.embed-url-2.org",
                            "embed_attributes": { "title": "First test photo update",
                                                  "slug": "updated-first-test-embed",
                                                  "source_type": 1 }
                          }}}

      let!(:embed) {
        EmbedApp.create!(source_url: 'http://test.embed-url.org', embed_attributes: { title: 'Embed app one', source_type: 0 })
      }

      let(:embed_id)   { embed.embed.id   }
      let(:embed_slug) { embed.embed.slug }

      context 'List filters' do
        let!(:disabled_embed) {
          EmbedApp.create!(source_url: 'http://test.embed-url.org', embed_attributes: { title: 'Embed app second', source_type: 0, slug: 'embed-app-second', status: 3, published: false })
        }

        let!(:enabled_embed) {
          Photo.create!(source_url: 'http://test.embed-url.org', embed_attributes: { title: 'Embed photo', source_type: 1, status: 1, published: true, thumbnail_url: 'http://test.embed-url.jpg' })
        }

        let!(:unpublished_embed) {
          Photo.create!(source_url: 'http://test.embed-url.org', embed_attributes: { title: 'Embed photo unpublished', source_type: 1, status: 1, published: false })
        }

        let!(:enabled_embed_source_partner) {
          Source.create!(url: 'http://test.embed-url.org', logo_url: 'http://test.embed-url.png', acronym: 'UN', partner: true, embed_attributes: { title: 'Source partner', source_type: 2, status: 1, published: true })
        }

        let!(:enabled_embed_source) {
          Source.create!(url: 'http://test.embed-url.org', logo_url: 'http://test.embed-url.png', acronym: 'UN', embed_attributes: { title: 'Source', source_type: 2, status: 1, published: true })
        }

        it 'Show list of all embeds' do
          get '/embeds?status=all'

          expect(status).to eq(200)
          expect(json.size).to eq(6)
        end

        it 'Show list of all embeds of type image' do
          get '/embeds?status=all&type=image'

          expect(status).to eq(200)
          expect(json.size).to eq(2)
        end

        it 'Show list of all embeds of type source' do
          get '/embeds?status=all&type=source'

          expect(status).to eq(200)
          expect(json.size).to eq(2)
          expect(json[0]['partner']).to eq(false)
          expect(json[1]['partner']).to eq(true)
        end

        it 'Show list of all embeds of type partner' do
          get '/embeds?status=all&type=partner'

          expect(status).to eq(200)
          expect(json.size).to          eq(1)
          expect(json[0]['partner']).to eq(true)
        end

        context 'Special routing for sources and partners' do
          it 'Show list of all embeds of type source' do
            get '/sources'

            expect(status).to eq(200)
            expect(json.size).to eq(2)
            expect(json[0]['partner']).to eq(false)
            expect(json[1]['partner']).to eq(true)
          end

          it 'Show list of all embeds of type partner' do
            get '/partners'

            expect(status).to eq(200)
            expect(json.size).to          eq(1)
            expect(json[0]['partner']).to eq(true)
          end
        end

        it 'Show list of all embeds of type app using status filter all' do
          get '/embeds?status=all&type=app'

          expect(status).to eq(200)
          expect(json.size).to eq(2)
        end

        it 'Show list of all embeds of type image' do
          get '/embeds?type=image'

          expect(status).to eq(200)
          expect(json.size).to eq(1)
        end

        it 'Show list of embeds with pending status' do
          get '/embeds?status=pending'

          expect(status).to eq(200)
          expect(json.size).to eq(1)
        end

        it 'Show list of embeds with active status' do
          get '/embeds?status=active'

          expect(status).to eq(200)
          expect(json.size).to eq(3)
        end

        it 'Show list of embeds with disabled status' do
          get '/embeds?status=disabled'

          expect(status).to eq(200)
          expect(json.size).to eq(1)
        end

        it 'Show list of embeds with published status true' do
          get '/embeds?published=true'

          expect(status).to eq(200)
          expect(json.size).to eq(3)
          expect(json[0]['published']).to eq(true)
        end

        it 'Show list of embeds with published status false' do
          get '/embeds?published=false'

          expect(status).to eq(200)
          expect(json.size).to eq(3)
          expect(json[0]['published']).to eq(false)
        end

        it 'Show list of embeds' do
          get '/embeds'

          expect(status).to eq(200)
          expect(json.size).to eq(3)
        end
      end

      it 'Show embed by slug' do
        get "/embeds/#{embed_slug}"

        expect(status).to eq(200)
        expect(json['slug']).to            eq('embed-app-one')
        expect(json['source_type']).to     eq('application')
        expect(json['meta']['status']).to  eq('pending')
      end

      it 'Show embed by id' do
        get "/embeds/#{embed_id}"

        expect(status).to eq(200)
      end

      context 'Create depending on type' do
        context 'For applications' do
          let(:params) {{"embed": {
                         "source_url": "http://test.embed-url.org",
                         "embed_attributes": { "title": "First test app",
                                               "source_type": 0 }
                       }}}

          it 'Allows to create app embed' do
            post '/embeds', params: params

            expect(status).to eq(201)
            expect(json['id']).to   be_present
            expect(json['slug']).to eq('first-test-app')
            expect(json['source_type']).to eq('application')
          end
        end

        context 'For images' do
          let(:params) {{"embed": {
                         "source_url": "http://test.embed-url.org",
                         "embed_attributes": { "title": "First test image",
                                               "source_type": 1 }
                       }}}

          it 'Allows to create app embed' do
            post '/embeds', params: params

            expect(status).to eq(201)
            expect(json['id']).to   be_present
            expect(json['slug']).to eq('first-test-image')
            expect(json['source_type']).to eq('image')
          end
        end

        context 'For sources' do
          let!(:partner_params) {{"embed": {
                                  "logo_url": "http://test.embed-url.org",
                                  "partner": true,
                                  "embed_attributes": { "title": "Second partner",
                                                        "source_type": '2'.to_i,
                                                        "status": '1'.to_i,
                                                        "published": true
                                  }
                                }}}

          it 'Allows to create partner embed' do
            post '/embeds', params: partner_params

            expect(status).to eq(201)
            expect(json['id']).to   be_present
            expect(json['slug']).to eq('second-partner')
            expect(json['source_type']).to eq('source')
          end
        end
      end

      it 'Allows to update embed' do
        put "/embeds/#{embed_slug}", params: update_params

        expect(status).to eq(200)
        expect(json['id']).to           be_present
        expect(json['title']).to        eq('First test photo update')
        expect(json['slug']).to         eq('updated-first-test-embed')
        expect(json['source_type']).to  eq('image')
      end

      it 'Allows to delete embed by id' do
        delete "/embeds/#{embed_id}"

        expect(status).to eq(200)
        expect(json['message']).to eq('Embed deleted')
        expect(Embed.where(id: embed_id)).to be_empty
      end

      it 'Allows to delete embed by slug' do
        delete "/embeds/#{embed_slug}"

        expect(status).to eq(200)
        expect(json['message']).to eq('Embed deleted')
        expect(Embed.where(slug: embed_slug)).to be_empty
      end
    end
  end
end
