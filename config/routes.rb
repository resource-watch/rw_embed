Rails.application.routes.draw do
  scope module: :v1, constraints: APIVersion.new(version: 1, current: true) do
    resources :embeds
    root to: 'embeds#docs'
  end
end
