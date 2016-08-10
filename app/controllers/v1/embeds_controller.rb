module V1
  class EmbedsController < ApplicationController
    before_action :basic_auth, only: [:update, :create, :destroy]
    before_action :set_embed,  only: [:show, :update, :destroy]

    def index
      @embeds = Embed.fetch_all(embed_type_filter)
      render json: @embeds, each_serializer: EmbedArraySerializer, root: false
    end

    def show
      render json: @embed, serializer: EmbedSerializer, root: false, meta: { status: @embed.try(:status_txt),
                                                                             updated_at: @embed.try(:updated_at),
                                                                             created_at: @embed.try(:created_at) }
    end

    def update
      if @embedable.update(embed_params)
        render json: @embed.reload, status: 200, serializer: EmbedSerializer, root: false
      else
        render json: { success: false, message: 'Error creating embed' }, status: 422
      end
    end

    def create
      @embedable = Embed.build_embed(embed_params)
      if @embedable.save
        render json: @embedable.embed, status: 201, serializer: EmbedSerializer, root: false
      else
        render json: { success: false, message: 'Error creating embed' }, status: 422
      end
    end

    def destroy
      @embed.destroy
      begin
        render json: { message: 'Embed deleted' }, status: 200
      rescue ActiveRecord::RecordNotDestroyed
        return render json: @embed.erors, message: 'Embed could not be deleted', status: 422
      end
    end

    def docs
      @docs = YAML.load(File.read('lib/files/swagger.yml')).to_json
      render json: @docs
    end

    def info
      @service = ServiceSetting.save_gateway_settings(params)
      if @service
        @docs = Oj.load(File.read("lib/files/service_#{ENV['RAILS_ENV']}.json"))
        render json: @docs
      else
        render json: { success: false, message: 'Missing url and token params' }, status: 422
      end
    end

    private

      def set_embed
        @embed     = Embed.find_by_id_or_slug(params[:id])
        @embedable = @embed.embedable
      end

      def embed_type_filter
        params.permit(:status, :type, :published)
      end

      def embed_params
        params.require(:embed).permit!
      end
  end
end
