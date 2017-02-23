Rails.application.routes.draw do
 
  resources :samples
  get 'products/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :products, only: [:index]

  get 'products/fetch_excel_data'

    get 'products/message'


ExcelNinja::Application.routes.draw do
  resources :samples
   resources :resumes, only: [:index, :new, :create, :destroy]
   root "resumes#index"
end

end
