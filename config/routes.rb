# frozen_string_literal: true
Rails.application.routes.draw do
  scope module: :v1, constraints: APIVersion.new(version: 1, current: true) do
    resources :embeds

    # For embeds of type Source and partner boolean
    get '/:type(s)' , to: 'embeds#index', constraints: { type: 'source'  }
    get '/:type(s)',  to: 'embeds#index', constraints: { type: 'partner' }

    get '/info', to: 'embeds#info'
    root         to: 'embeds#docs'
  end
end
