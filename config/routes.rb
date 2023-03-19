Rails.application.routes.draw do
  resources :students
  resources :courses
  resources :groups

  get 'group/:id/course/:course_id', to: 'groups#grade', as: 'grade_group'
  post 'group/:id/course/:course_id/save', to: 'groups#gradesave', as: 'save_grade_group'


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
