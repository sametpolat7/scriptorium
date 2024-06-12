Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  scope "(:locale)", locale: /en|tr/ do

    resources :users, param: :username do
      resources :comments do
        member do
          patch :approve
          patch :reject
        end
      end
      member do
        get :my_drafts, to: "users#user_drafts"
        get :articles_all, to: "users#user_articles"
      end
    end

    resources :articles do
      member do
        put "increment_like_count"
      end
      resources :comments, only: [:create]
    end

    namespace :api do
      resources :articles, only: [:index, :show]
    end

    get '/search', to: "articles#search"

    get "up" => "rails/health#show", as: :rails_health_check

    # Defines the root path route ("/")
    root "welcome#index"
  end

  get '*path', to: redirect("/%{locale}/%{path}", locale: I18n.default_locale)
  get '', to: redirect("/%{locale}", locale: I18n.default_locale)

end
