class Student < ApplicationRecord
  belongs_to :group
  has_many :course_students
  has_many :courses, through: :course_students
  has_many :grades


  def i_n
    imie+' '+nazwisko
  end
end
