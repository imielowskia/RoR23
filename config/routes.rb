Rails.application.routes.draw do
  resources :students
  resources :courses
  resources :groups

  get 'groups/:id/course/:course_id', to: 'groups#grade', as: 'grade_group'
  post 'groups/:id/course/:course_id/save', to: 'groups#gradesave', as: 'save_grade_group'

  get 'courses/:id/group/:group_id', to: 'courses#grade', as: 'grade_course'
  get 'courses/:id/group/:group_id/student/:student_id', to: 'courses#grade_student', as: 'grade_course_student'
  post 'courses/:id/group/:group_id/student/:student_id', to:'courses#grade_student_save', as: 'save_grade_course_student'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
