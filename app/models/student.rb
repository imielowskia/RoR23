class Student < ApplicationRecord
  belongs_to :group

  def i_n
    imie+' '+nazwisko
  end
end
