require 'acceptance_helper'

module V1
  describe 'Embeds', type: :request do
    context 'Create, update and delete embeds' do
      let!(:params) {{"embed": {
                      "source_url": "http://test.embed-url.org",
                      "embed_attributes": { "title": "First test embed",
                                            "source_type": 0 }
                    }}}

      let!(:update_params) {{"embed": {
                             "source_url": "http://test.embed-url-2.org",
                             "embed_attributes": { "title": "First test photo update",
                                                   "slug": "updated-first-test-embed",
                                                   "source_type": 1 }
                           }}}

      let!(:embed) {
        EmbedApp.create!(source_url: 'http://test.embed-url.org', embed_attributes: { title: 'Embed app one', source_type: 0 })
      }

      let!(:embed_id)   { embed.embed.id   }
      let!(:embed_slug) { embed.embed.slug }

      context 'List filters' do
        let!(:disabled_embed) {
          EmbedApp.create!(source_url: 'http://test.embed-url.org', embed_attributes: { title: 'Embed app second', source_type: 0, slug: 'embed-app-second', status: 3 })
        }

        let!(:enabled_embed) {
          Photo.create!(source_url: 'http://test.embed-url.org', embed_attributes: { title: 'Embed photo', source_type: 1, status: 1 })
        }

        it 'Show list of all embeds' do
          get '/embeds?status=all'

          expect(status).to eq(200)
          expect(json.size).to eq(3)
        end

        it 'Show list of all embeds of type image' do
          get '/embeds?status=all&type=image'

          expect(status).to eq(200)
          expect(json.size).to eq(1)
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
          expect(json.size).to eq(1)
        end

        it 'Show list of embeds with disabled status' do
          get '/embeds?status=disabled'

          expect(status).to eq(200)
          expect(json.size).to eq(1)
        end

        it 'Show list of embeds' do
          get '/embeds'

          expect(status).to eq(200)
          expect(json.size).to eq(1)
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

      it 'Allows to create app embed' do
        post '/embeds', params: params

        expect(status).to eq(201)
        expect(json['id']).to   be_present
        expect(json['slug']).to eq('first-test-embed')
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
